//
//  GeocodeReverseResponse.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

public struct GeocodeReverseResponse: Codable {
    public let features: [GeocodeReverseFeature]
}

public struct GeocodeReverseFeature: Codable {
    public let type: String
    public let properties: GeocodeReverseProperties
}

public struct GeocodeReverseProperties: Codable {
    public let country: String
    public let countryCode: String
    public let city: String

    enum CodingKeys: String, CodingKey {
        case country
        case countryCode = "country_code"
        case city
    }
}
