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
        forcedDuration: Int? = nil,
        isResumption: Bool = false
    ) async throws {
        guard blockItem.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }
        guard case let .duration(originalDuration, _, _, _) = blockItem.type else { return }

        // Start blocking immediately.
        try await shieldManager.block(specific: blockItem.blockedContent)

        // Build schedule based on seconds. DeviceActivitySchedule requires >= 15 minutes interval.
        let nowComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: await clock.now)
        let durationSeconds = forcedDuration ?? originalDuration.rawValue
        let intervalStart = nowComponents.adding(seconds: durationSeconds)
        let intervalEnd = intervalStart.adding(seconds: Self.fallbackIntervalSeconds)

        let schedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false)

        let activityName = try createActivityName(for: blockItem, actionType: .regular)
        try await centerManager.startMonitoring(activityName, during: schedule)

        // Persist start time and absolute end date.
        let startTime = await clock.now
        let actualTimeBeforeEnd = await computeActualTimeBeforeEnd(intervalStart: intervalStart, forcedDuration: forcedDuration, originalDuration: originalDuration)
        let endDate = startTime.addingTimeInterval(TimeInterval(max(0, actualTimeBeforeEnd)))

        var copy = blockItem
        copy.type = .duration(originalDuration, suspendedAt: nil, suspendedUntil: nil, endDate: endDate)
        try await blockItemPersistenceManager.editBlockItem(blockItem: copy)
    }

    func registerRegularActivity(for blockItem: ProtectedBlockItem, startTime: TimeComponents, endTime: TimeComponents) async throws {
        guard blockItem.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }

        let schedule = DeviceActivitySchedule(intervalStart: startTime.dateComponents, intervalEnd: endTime.dateComponents, repeats: true)

        let overlaps = try await overlapsWithAlreadyRegisteredSchedules(schedule, days: blockItem.days)
        guard overlaps.isEmpty else { throw DeviceActivityRegistrarError.scheduleOverlap(with: overlaps) }

        let activityName = try createActivityName(for: blockItem, actionType: .regular)
        try await centerManager.startMonitoring(activityName, during: schedule)
    }

    func registerFallbackActivity(for blockItem: ProtectedBlockItem, startTime: TimeComponents, endTime: TimeComponents) async throws {
        guard blockItem.persistentModelID != nil else { throw DeviceActivityRegistrarError.noPersistentItem }

        // Shift end to satisfy DeviceActivityCenter (workaround)
        let intervalEnd = endTime.dateComponents.adding(seconds: Self.fallbackIntervalSeconds)
        let schedule = DeviceActivitySchedule(intervalStart: startTime.dateComponents, intervalEnd: intervalEnd, repeats: true)

        let overlaps = try await overlapsWithAlreadyRegisteredSchedules(schedule, days: blockItem.days)
        guard overlaps.isEmpty else { throw DeviceActivityRegistrarError.scheduleOverlap(with: overlaps) }

        let activityName = try createActivityName(for: blockItem, actionType: .fallback)
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

    func overlapsWithAlreadyRegisteredSchedules(
        _ newSchedule: DeviceActivitySchedule,
        days: Set<Weekday>,
        on calendar: Calendar = .current
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

            if start1 < end2 && start2 < end1 {
                guard let decoded = CodableActivityIdentifier(from: activity) else {
                    throw DeviceActivityRegistrarError.couldNotCheckOverlap
                }
                let blockItemID = decoded.blockItemID
                if let overlappingBlock = try await blockItemPersistenceManager.fetch(by: blockItemID), overlappingBlock.days.isDisjoint(with: days) == false {
                    overlapping.append(overlappingBlock)
                }
            }
        }

        return overlapping
    }

    func startActivityIfRegisteredDuringIntervalWindow(item: ProtectedBlockItem) async throws {
        guard case .scheduled = item.type else { return }

        let timeLeftInSeconds = item.type.secondsToIntervalEndIfShouldBeRunning(now: await clock.now)
        guard let timeLeft = timeLeftInSeconds else { return }

        // Create temporary duration block and schedule it immediately.
        var temp = ProtectedBlockItem(
            emoji: "⏳",
            name: "temp-" + UUID().uuidString,
            days: item.days,
            type: .duration(.init(duration: timeLeft)),
            isTemporary: true,
            blockedContent: item.blockedContent
        )

        try await blockItemPersistenceManager.insert(&temp)
        try await registerDurationActivity(for: temp, forcedDuration: timeLeft)
    }

    // Compute actual seconds until end using existing logic (keeps previous behaviour).
    func computeActualTimeBeforeEnd(intervalStart: DateComponents, forcedDuration: Int?, originalDuration: DurationComponents) async -> Int {
        if let forced = forcedDuration { return forced }
        if let hour = intervalStart.hour, let minute = intervalStart.minute {
            let endTime = (try? TimeComponents(hour: hour, minute: minute).localizedSecondsSinceMidnight) ?? originalDuration.rawValue
            let currentSecond = await clock.now.secondsSinceMidnight()
            return endTime - currentSecond
        }
        return originalDuration.rawValue
    }

    static func adjustedEndDate(endDate: Date, suspendedAt: Date?, resumedAt: Date) -> Date {
        guard let suspendedAt else { return endDate }
        let suspendedDuration = resumedAt.timeIntervalSince(suspendedAt)
        return endDate.addingTimeInterval(suspendedDuration)
    }
}

