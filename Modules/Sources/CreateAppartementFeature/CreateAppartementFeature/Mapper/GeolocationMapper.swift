//
//  GeolocationMapper.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation
import FHRepository

enum GeolocationMapper {
    static func mapToGeolocation(
        from: GeocodeReverseResponse
    ) -> GeolocationModel? {
        guard let properties = from.features.first?.properties else {
            return nil
        }
        return GeolocationModel(
            country: properties.country,
            countryCode: properties.countryCode.uppercased(),
            city: properties.city
        )
    }
}
