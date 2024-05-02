//
//  AppartementMapper.swift
//
//
//  Created by Kostya Tsyvilko on 22.04.24.
//

import Foundation

enum AppartementMapper {
    static func mapToAppartementDTO(
        from: CreateAppartementDTO
    ) -> AppartementDTO {
        AppartementDTO(
            id: from.id,
            hostUserId: from.hostUserId,
            title: from.title,
            city: from.city,
            country: from.county,
            countryCode: from.countryCode,
            pricePerNight: from.pricePerNight,
            guestCount: from.guestsCount,
            photosStringURL: from.photosStringURL,
            createDate: from.createDate
        )
    }

    static func mapToAppartementInfoDTO(
        from: CreateAppartementDTO
    ) -> AppartementInfoDTO {
        AppartementInfoDTO(
            appartementId: from.id,
            latitude: from.latitude,
            longitude: from.longitude,
            description: from.description,
            bedrooms: from.bedrooms,
            beds: from.beds,
            bathrooms: from.bathrooms,
            type: from.type,
            livingType: from.livingType,
            offers: from.offers,
            descriptionTypes: from.descriptionTypes,
            cancellationPolicy: from.cancellationPolicy
        )
    }

    static func mapToAppartementDetailsDTO(
        from: CreateAppartementDTO
    ) -> AppartementDetailsDTO {
        let info = mapToAppartementInfoDTO(from: from)
        return AppartementDetailsDTO(
            id: from.id,
            hostUserId: from.hostUserId,
            title: from.title,
            city: from.city,
            country: from.county,
            countryCode: from.countryCode,
            pricePerNight: from.pricePerNight,
            guestCount: from.guestsCount,
            photosStringURL: from.photosStringURL,
            createDate: from.createDate,
            info: info
        )
    }

    static func mapToAppartementDetailsDTO(
        from appartement: AppartementDTO,
        with info: AppartementInfoDTO
    ) -> AppartementDetailsDTO {
        AppartementDetailsDTO(
            id: appartement.id,
            hostUserId: appartement.hostUserId,
            title: appartement.title,
            city: appartement.city,
            country: appartement.country,
            countryCode: appartement.countryCode,
            isAvailableForBook: appartement.isAvailableForBook,
            pricePerNight: appartement.pricePerNight,
            guestCount: appartement.guestCount,
            rating: appartement.rating,
            reviewCount: appartement.reviewCount,
            photosStringURL: appartement.photosStringURL,
            createDate: appartement.createDate,
            info: info
        )
    }

    static func mapToExploreAppartementDTO(
        from appartement: AppartementDTO,
        isFavourite: Bool
    ) -> ExploreAppartementDTO {
        ExploreAppartementDTO(
            id: appartement.id,
            hostUserId: appartement.hostUserId,
            title: appartement.title,
            city: appartement.city,
            country: appartement.country,
            countryCode: appartement.countryCode,
            isAvailableForBook: appartement.isAvailableForBook,
            pricePerNight: appartement.pricePerNight,
            guestCount: appartement.guestCount,
            isFavourite: isFavourite,
            rating: appartement.rating,
            reviewCount: appartement.reviewCount,
            photosStringURL: appartement.photosStringURL,
            createDate: appartement.createDate
        )
    }

    static func mapToFavouriteAppartementDTO(
        with userId: String,
        appartement: AppartementDTO
    ) -> FavouriteAppartementDTO {
        FavouriteAppartementDTO(
            userId: userId,
            appartement: appartement
        )
    }
}
