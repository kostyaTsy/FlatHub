//
//  Date+Components.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation

public extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }

    func startOfMonth() -> Date? {
        Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.year, .month, .day],
                from: Calendar.current.startOfDay(for: self)
            )
        )
    }

    func endOfMonth() -> Date? {
        guard let start = startOfMonth() else {
            return nil
        }
        return Calendar.current.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: start
        )
    }

    func nextMonth() -> Date? {
        Calendar.current.date(byAdding: .month, value: 1, to: self)
    }

    func prevMonth() -> Date? {
        Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
}
