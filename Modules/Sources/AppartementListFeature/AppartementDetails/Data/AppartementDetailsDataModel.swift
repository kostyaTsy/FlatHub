//
//  AppartementDetailsDataModel.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

public final class AppartementDetailsDataModel {
    var searchDates: SearchDates?
    var bookDates: BookDates?
    var bookingId: String?

    public init(
        searchDates: SearchDates? = nil,
        bookDates: BookDates? = nil,
        bookingId: String? = nil
    ) {
        self.searchDates = searchDates
        self.bookDates = bookDates
        self.bookingId = bookingId
    }
}

public struct BookDates {
    public let startDate: Date
    public let endDate: Date

    public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
