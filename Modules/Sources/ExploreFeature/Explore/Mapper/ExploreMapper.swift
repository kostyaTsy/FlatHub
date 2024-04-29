//
//  ExploreMapper.swift
//
//
//  Created by Kostya Tsyvilko on 29.04.24.
//

import Foundation
import FHRepository

enum ExploreMapper {
    static func mapToSearchDTO(
        from model: SearchModel
    ) -> AppartementSearchDTO {
        AppartementSearchDTO(
            city: model.city,
            countryCode: model.countryCode,
            startDate: model.startDate,
            endDate: model.endDate,
            guestsCount: model.guestsCount
        )
    }
}
