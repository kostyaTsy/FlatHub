//
//  Date+Count.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

public extension Date {
    func daysBetween(_ other: Date) -> Int? {
        Calendar.current.dateComponents([.day], from: self, to: other).day
    }
}
