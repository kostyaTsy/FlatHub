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
