//
//  AppartementDetailsDataModel.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

public final class AppartementDetailsDataModel {
    var searchDates: SearchDates?

    public init(searchDates: SearchDates? = nil) {
        self.searchDates = searchDates
    }
}
