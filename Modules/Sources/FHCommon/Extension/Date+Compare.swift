//
//  Date+Compare.swift
//  
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation

public extension Date {
    func isEqual(_ other: Date, with components: Calendar.Component...) -> Bool {
        for component in components {
            if self.get(component) != other.get(component) {
                return false
            }
        }

        return true
    }
}
