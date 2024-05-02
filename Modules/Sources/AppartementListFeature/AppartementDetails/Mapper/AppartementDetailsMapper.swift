//
//  AppartementDetailsMapper.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation
import FHRepository

enum AppartementDetailsMapper {
    static func mapToDataModel(
        with searchDates: SearchDates?
    ) -> AppartementDetailsDataModel {
        AppartementDetailsDataModel(
            searchDates: searchDates
        )
    }

    static func mapToBookRequestDTO(
        with appartement: AppartementModel,
        userId: String,
        startDate: Date,
        endDate: Date
    ) -> BookAppartementRequestDTO {
        BookAppartementRequestDTO(
            userId: userId,
            hostUserId: appartement.hostUserId,
            appartementId: appartement.id,
            startDate: startDate,
            endDate: endDate
        )
    }
}
