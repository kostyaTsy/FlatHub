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
}
