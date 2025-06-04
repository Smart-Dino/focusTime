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
            if ($0.trialPeriod != nil) != ($1.trialPeriod != nil) {
                return ($0.trialPeriod != nil) && !($1.trialPeriod != nil)
            } else {
                return $0.price < $1.price
            }
        }
    }
}
