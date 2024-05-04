//
//  SearchCountry.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation

public struct SearchCity: Identifiable {
    public let id: UUID
    let city: String
    let countryCode: String

    var location: String {
        "\(city), \(countryCode)"
    }

    public init(
        id: UUID = UUID(),
        city: String,
        countryCode: String
    ) {
        self.id = id
        self.city = city
        self.countryCode = countryCode
    }
}
