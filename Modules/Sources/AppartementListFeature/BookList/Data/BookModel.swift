//
//  BookModel.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation
import FHRepository

public struct BookModel: Identifiable {
    public let id: UUID = UUID()
    let appartement: AppartementModel
    let status: BookStatus
    let startDate: Date
    let endDate: Date

    var datesRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"

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

    public init(
        appartement: AppartementModel,
        status: BookStatus,
        startDate: Date,
        endDate: Date
    ) {
        self.appartement = appartement
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
    }
}
