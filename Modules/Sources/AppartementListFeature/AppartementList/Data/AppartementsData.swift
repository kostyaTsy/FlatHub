//
//  AppartementsData.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

public struct AppartementsData {
    let appartements: [AppartementModel]
    let searchDates: SearchDates?

    public init(
        appartements: [AppartementModel],
        searchDates: SearchDates? = nil
    ) {
        self.appartements = appartements
        self.searchDates = searchDates
    }
}

public struct SearchDates {
    let startDate: Date
    let endDate: Date

    public init(
        startDate: Date,
        endDate: Date
    ) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
