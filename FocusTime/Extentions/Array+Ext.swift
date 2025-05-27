//
//  Array+Ext.swift
//  FocusTime
//
//  Created by Maksym Horobets on 27.05.2025.
//

extension Array where Element == FTProduct {
    func sortByPrice() -> [FTProduct] {
        self.sorted(by: { return $0.price < $1.price })
    }
    
    func sortByTrialThenPrice() -> [FTProduct] {
        self.sorted {
            if $0.isTrialable != $1.isTrialable {
                return $0.isTrialable && !$1.isTrialable
            } else {
                return $0.price < $1.price
            }
        }
    }
}
