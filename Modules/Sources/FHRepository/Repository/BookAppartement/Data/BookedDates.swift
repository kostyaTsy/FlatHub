//
//  BookedDates.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

public struct BookedDates {
    public let startDate: Date
    public let endDate: Date

    public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
