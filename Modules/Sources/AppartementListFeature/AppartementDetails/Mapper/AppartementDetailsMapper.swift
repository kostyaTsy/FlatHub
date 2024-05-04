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
        searchDates: SearchDates? = nil,
        bookDates: BookDates? = nil,
        bookingId: String? = nil
    ) -> AppartementDetailsDataModel {
        AppartementDetailsDataModel(
            searchDates: searchDates,
            bookDates: bookDates,
            bookingId: bookingId
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

    static func mapToCancelBookingDTO(
        with bookingId: String,
        with params: CancelBookingParams
    ) -> CancelBookingDTO {
        CancelBookingDTO(
            bookingId: bookingId,
            refundPercentage: params.refundPercentage
        )
    }

    static func mapToAddRatingModel(
        from appartement: AppartementModel
    ) -> AddRatingModel {
        AddRatingModel(
            appartementId: appartement.id,
            hostUserId: appartement.hostUserId
        )
    }

    static func mapToAppartementInfoModel(
        from info: AppartementInfoDTO
    ) -> AppartementInfoModel {
        AppartementInfoModel(
            latitude: info.latitude,
            longitude: info.longitude,
            description: info.description,
            bedrooms: info.bedrooms,
            beds: info.beds,
            bathrooms: info.bathrooms,
            type: info.type,
            livingType: info.livingType,
            offers: info.offers,
            descriptionTypes: info.descriptionTypes,
            cancellationPolicy: info.cancellationPolicy
        )
    }
}
