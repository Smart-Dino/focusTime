//
//  LiveDeviceActivityRegistrar+Helpers.swift
//  FocusTime
//
//  Created by Maksym Horobets on 28.07.2025.
//

import Foundation
import DeviceActivity

extension LiveDeviceActivityRegistrar {
    // MARK: - Register helpers (duration / regular / fallback)

    func registerDurationActivity(
        for blockItem: ProtectedBlockItem,
        forcedDuration: Int? = nil
    ) async throws {
        guard blockItem.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }
        guard case let .duration(originalDuration, _, _, _) = blockItem.type else { return }
        let startTime = await clock.now

        // Start blocking immediately.
        try await shieldManager.block(specific: blockItem.blockedContent)

        // Build schedule based on seconds. DeviceActivitySchedule requires >= 15 minutes interval.
        let nowComponents = calendar.dateComponents([.hour, .minute, .second], from: startTime)
        let durationSeconds = forcedDuration ?? originalDuration.rawValue
        let intervalStart = nowComponents.adding(seconds: durationSeconds)
        let intervalEnd = intervalStart.adding(seconds: Self.fallbackIntervalSeconds)

        let schedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false)

        let activityName = try createActivityName(for: blockItem, actionType: blockItem.isTemporary == nil ? .regular : .regularTemp)
        try await centerManager.startMonitoring(activityName, during: schedule)

        let timeBeforeEnd = forcedDuration ?? originalDuration.rawValue
        let endDate = startTime.addingTimeInterval(TimeInterval(max(0, timeBeforeEnd)))

        var copy = blockItem
        copy.type = .duration(duration: originalDuration, suspendedAt: nil, suspendedUntil: nil, endDate: endDate)
        try await blockItemPersistenceManager.editBlockItem(blockItem: copy)
    }

    func registerRegularActivity(for blockItem: ProtectedBlockItem, startTime: TimeComponents, endTime: TimeComponents) async throws {
        guard blockItem.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }
        
        if let activity = try? await getActivityForSchedule(blockItem) {
            await centerManager.stopMonitoring([activity]) // Re-register activity.
        }

        let schedule = DeviceActivitySchedule(intervalStart: startTime.dateComponents, intervalEnd: endTime.dateComponents, repeats: true)

        let overlaps = try await overlapsWithAlreadyRegisteredSchedules(schedule, days: blockItem.days)
        guard overlaps.isEmpty else { throw DeviceActivityRegistrarError.scheduleOverlap(with: overlaps) }

        let activityName = try createActivityName(for: blockItem, actionType: blockItem.isTemporary == nil ? .regular : .regularTemp)
        try await centerManager.startMonitoring(activityName, during: schedule)
    }

    // MARK: - Utilities & Small helpers

    func createActivityName(
        for blockItem: ProtectedBlockItem,
        actionType: CodableActivityIdentifier.BlockType
    ) throws -> DeviceActivityName {
        guard let identifier = CodableActivityIdentifier(
            blockItemID: blockItem.id,
            blockType: actionType
        ).jsonString else {
            throw DeviceActivityRegistrarError.couldNotGenerateIdentifier
        }
        
        return DeviceActivityName(identifier)
    }

    func getActivityForSchedule(_ blockItem: ProtectedBlockItem) async throws -> DeviceActivityName {
        // Decode existing activity name from list of registered activities.
        let activities = await centerManager.activities
        for activity in activities {
            if let decoded = CodableActivityIdentifier(from: activity), decoded.blockItemID == blockItem.id {
                return activity
            }
        }
        throw DeviceActivityRegistrarError.activityNotFound
    }
    
    func validateNoOverlapForDurationBlocking(proposedDuration: Int) async throws {
        let now = await clock.now

        // Fetch the next block. If none exists, there is no possibility of an overlap.
        guard let nextBlock = try await blockItemPersistenceManager.fetchClosestOrRunningCurrentScheduled(now: now) else {
            return
        }

        // Ignore the cancelled block.
        guard !nextBlock.isCancelled else {
            return
        }

        // Determine if an overlap condition is met.
        let isOverlapping: Bool

        if nextBlock.type.secondsToIntervalEndIfShouldBeRunning(now: now) != nil {
            // If the block is already running - it will definitely overlap.
            isOverlapping = true
        } else if case .scheduled(let startTime, _, _, _, _) = nextBlock.type {
            // Check if the proposed duration extends beyond the start time of the next scheduled block.
            let startOfToday = calendar.startOfDay(for: now)
            var scheduledBlockStartTime = startOfToday.addingTimeInterval(
                TimeInterval(startTime.localizedSecondsSinceMidnight)
            )

            // If that scheduled start is already in the past today, roll it over to tomorrow.
            if scheduledBlockStartTime <= now {
                scheduledBlockStartTime = calendar.date(byAdding: .day, value: 1, to: scheduledBlockStartTime)!
            }

            let proposedEndTime = now.addingTimeInterval(TimeInterval(proposedDuration))
            isOverlapping = proposedEndTime > scheduledBlockStartTime
        } else {
            isOverlapping = false
        }

        // If any overlap condition was met - throw error.
        if isOverlapping {
            throw DeviceActivityRegistrarError.scheduleOverlap(with: [nextBlock])
        }
    }

    func overlapsWithAlreadyRegisteredSchedules(
        _ newSchedule: DeviceActivitySchedule,
        days: Set<Weekday>
    ) async throws -> [ProtectedBlockItem] {
        var overlapping: [ProtectedBlockItem] = []
        let activities = await centerManager.activities
        
        for activity in activities {
            guard
                let existingSchedule = await centerManager.schedule(for: activity),
                let start1 = calendar.date(from: newSchedule.intervalStart),
                let end1 = calendar.date(from: newSchedule.intervalEnd),
                let start2 = calendar.date(from: existingSchedule.intervalStart),
                let end2 = calendar.date(from: existingSchedule.intervalEnd)
            else {
                throw DeviceActivityRegistrarError.couldNotCheckOverlap
            }
            
            if start1 <= end2 && start2 <= end1 {
                guard let decoded = CodableActivityIdentifier(from: activity) else {
                    throw DeviceActivityRegistrarError.couldNotCheckOverlap
                }
                let blockItemID = decoded.blockItemID
                if let overlappingBlock = try await blockItemPersistenceManager.fetch(by: blockItemID), overlappingBlock.days.isDisjoint(with: days) == false {
                    overlapping.append(overlappingBlock)
                }
            }
        }
        
        return overlapping.filter { $0.isTemporary == nil }
    }

    func startActivityIfRegisteredDuringIntervalWindow(item: ProtectedBlockItem) async throws {
        guard item.days.contains(Weekday.currentDay) else { return }
        guard case .scheduled = item.type else { return }

        let timeLeftInSeconds = item.type.secondsToIntervalEndIfShouldBeRunning(now: await clock.now)
        guard let timeLeft = timeLeftInSeconds, !item.isCancelled else { return }

        // Create temporary duration block and schedule it immediately.
        var temp = ProtectedBlockItem(
            emoji: "⏳",
            name: UUID().uuidString,
            days: item.days,
            type: .duration(duration: .init(seconds: timeLeft)),
            isTemporary: .relatedTo(blockID: item.id),
            blockedContent: item.blockedContent
        )

        try await blockItemPersistenceManager.insert(&temp)
        try await registerDurationActivity(for: temp, forcedDuration: timeLeft)
    }
    
    /// Finds and deletes a temporary block associated with a primary block's ID.
    func cleanupTemporaryBlock(relatedTo originalBlockID: UUID) async throws {
        let allBlocks = try await blockItemPersistenceManager.fetchTemporary()

        guard let tempBlock = allBlocks.first(where: { block in
            if case .relatedTo(let relatedID) = block.isTemporary {
                return relatedID == originalBlockID
            }
            return false
        }) else { return }

        // Use `try?` as cleanup failure shouldn't halt the main cancellation flow.
        try? await cancelScheduledResume(for: tempBlock)
        try? await removeTempBlockRelated(to: tempBlock)
        try? await blockItemPersistenceManager.delete(blockItem: tempBlock)
    }
    
    static func adjustedEndDate(endDate: Date, suspendedAt: Date?, resumedAt: Date) -> Date {
        guard let suspendedAt else { return endDate }
        let suspendedDuration = resumedAt.timeIntervalSince(suspendedAt)
        return endDate.addingTimeInterval(suspendedDuration)
    }
}

