//
//  SearchMapper.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation
import FHRepository

enum SearchMapper {
    static func mapToSearchCity(
        from response: SearchCityResponse
    ) -> SearchCity {
        SearchCity(
            city: response.city,
            countryCode: response.countryCode
        )
    }
}
