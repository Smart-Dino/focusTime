//
//  FamilyActivitySelection+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.08.2025.
//

import Foundation
import FamilyControls

// This one is a struct(struct) which is holding 3 sets of tokens, which are also struts.
// So I will assume we copy this value across concurrency domains and leave it at that.
extension FamilyActivitySelection: @retroactive @unchecked Sendable { }

extension FamilyActivitySelection: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.applicationTokens)
        hasher.combine(self.categoryTokens)
        hasher.combine(self.webDomainTokens)
    }
}

extension FamilyActivitySelection {
    /// Returns true if the selection contains no tokens and
    /// does not include entire categories.
    var isEmpty: Bool {
        applicationTokens.isEmpty &&
        categoryTokens.isEmpty &&
        webDomainTokens.isEmpty &&
        !includeEntireCategory
    }
    
    /// Merges two `FamilyActivitySelection` values into one,
    /// combining their tokens and respecting the `includeEntireCategory` flag.
    ///
    /// - Parameter other: The other selection to merge with.
    /// - Returns: A new `FamilyActivitySelection` containing the union
    ///   of applications, categories, and web domains from both selections.
    func merged(with other: FamilyActivitySelection) -> FamilyActivitySelection {
        var merged = FamilyActivitySelection(
            includeEntireCategory: self.includeEntireCategory || other.includeEntireCategory
        )

        merged.applicationTokens = self.applicationTokens.union(other.applicationTokens)
        merged.categoryTokens = self.categoryTokens.union(other.categoryTokens)
        merged.webDomainTokens = self.webDomainTokens.union(other.webDomainTokens)

        return merged
    }
}
