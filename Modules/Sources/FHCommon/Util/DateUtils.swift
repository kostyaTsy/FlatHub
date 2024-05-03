//
//  DateUtils.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

public enum DateUtils {
    public static func makeDatesRangeString(
        startDate: Date,
        endDate: Date,
        dateFormat: String = "d MMM"
    ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        if startDate.isEqual(endDate, with: .day, .month, .year) {
            return dateFormatter.string(from: startDate)
        }

        if startDate.get(.month) == endDate.get(.month) {
            let startDay = startDate.get(.day)
            let formattedEndDate = dateFormatter.string(from: endDate)

            return "\(startDay) - \(formattedEndDate)"
        }

        let formattedStartDate = dateFormatter.string(from: startDate)
        let formattedEndDate = dateFormatter.string(from: endDate)

        return "\(formattedStartDate) - \(formattedEndDate)"
    }

    public static func makeFormattedDate(
        date: Date,
        format: String = "MMMM"
    ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: date)
    }
}
