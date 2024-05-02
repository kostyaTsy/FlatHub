//
//  AppartementMapper.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation
import FHRepository

public enum AppartementMapper {
    public static func mapToAppartementModel(
        from appartementDTO: ExploreAppartementDTO
    ) -> AppartementModel {
        AppartementModel(
            id: appartementDTO.id,
            hostUserId: appartementDTO.hostUserId,
            title: appartementDTO.title,
            city: appartementDTO.city,
            countryCode: appartementDTO.countryCode,
            pricePerNight: appartementDTO.pricePerNight,
            guestCount: appartementDTO.guestCount,
            isFavourite: appartementDTO.isFavourite,
            rating: appartementDTO.rating,
            reviewCount: appartementDTO.reviewCount,
            photos: appartementDTO.photosStringURL,
            createDate: appartementDTO.createDate
        )
    }

    public static func mapToAppartementModel(
        from appartementDTO: AppartementDTO
    ) -> AppartementModel {
        AppartementModel(
            id: appartementDTO.id,
            hostUserId: appartementDTO.hostUserId,
            title: appartementDTO.title,
            city: appartementDTO.city,
            countryCode: appartementDTO.countryCode,
            pricePerNight: appartementDTO.pricePerNight,
            guestCount: appartementDTO.guestCount,
            isFavourite: false,
            rating: appartementDTO.rating,
            reviewCount: appartementDTO.reviewCount,
            photos: appartementDTO.photosStringURL,
            createDate: appartementDTO.createDate
        )
    }

    public static func mapToAppartementsData(
        with appartements: [AppartementModel],
        startSearchDate: Date? = nil,
        endSearchDate: Date? = nil
    ) -> AppartementsData {
        var searchDates: SearchDates?
        if let startSearchDate, let endSearchDate {
            searchDates = SearchDates(
                startDate: startSearchDate,
                endDate: endSearchDate
            )
        }

        return AppartementsData(
            appartements: appartements,
            searchDates: searchDates
        )
    }

    static func mapToFavouriteAppartementDTO(
        for userId: String,
        from appartementId: String
    ) -> FavouriteAppartementRequestDTO {
        FavouriteAppartementRequestDTO(
            userId: userId,
            appartementId: appartementId
        )
    }
}
