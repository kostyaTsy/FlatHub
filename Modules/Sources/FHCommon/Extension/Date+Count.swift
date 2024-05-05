//
//  Date+Count.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

public extension Date {
    func daysBetween(_ other: Date) -> Int? {
        guard let daysCount = Calendar.current.dateComponents([.day], from: self, to: other).day else {
            return nil
        }

        return abs(daysCount) + 1 // +1 to take into account the start date
    }
}
