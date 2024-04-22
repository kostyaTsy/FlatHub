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
            photosStringURL: from.photosStringURL
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
}
