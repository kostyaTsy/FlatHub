//
//  ListingsMapper.swift
//
//
//  Created by Kostya Tsyvilko on 24.04.24.
//

import Foundation
import AppartementListFeature
import CreateAppartementFeature
import FHRepository

enum ListingsMapper {
    static func mapToHostAppartement(
        from appartementDetails: AppartementDetailsDTO
    ) -> HostAppartement {
        HostAppartement(
            id: appartementDetails.id,
            hostUserId: appartementDetails.hostUserId,
            title: appartementDetails.title,
            city: appartementDetails.city,
            country: appartementDetails.country,
            countryCode: appartementDetails.countryCode,
            isAvailableForBook: appartementDetails.isAvailableForBook,
            pricePerNight: appartementDetails.pricePerNight,
            guestCount: appartementDetails.guestCount,
            rating: appartementDetails.rating,
            reviewCount: appartementDetails.reviewCount,
            photosStringURL: appartementDetails.photosStringURL,
            createDate: appartementDetails.createDate,
            details: mapToHostAppartementDetails(from: appartementDetails.info)
        )
    }

    static func mapToHostAppartementDetails(
        from appartementInfo: AppartementInfoDTO
    ) -> HostAppartementDetails {
        HostAppartementDetails(
            appartementId: appartementInfo.appartementId,
            latitude: appartementInfo.latitude,
            longitude: appartementInfo.longitude,
            description: appartementInfo.description,
            bedrooms: appartementInfo.bedrooms,
            beds: appartementInfo.beds,
            bathrooms: appartementInfo.bathrooms,
            type: appartementInfo.type,
            livingType: appartementInfo.livingType,
            offers: appartementInfo.offers,
            descriptionTypes: appartementInfo.descriptionTypes,
            cancellationPolicy: appartementInfo.cancellationPolicy
        )
    }

    static func mapToCreateAppartement(
        from appartement: HostAppartement
    ) -> CreateAppartement {
        CreateAppartement(
            id: appartement.id,
            type: appartement.details.type,
            livingType: appartement.details.livingType,
            longitude: appartement.details.longitude,
            latitude: appartement.details.latitude,
            city: appartement.city,
            country: appartement.country,
            countryCode: appartement.countryCode,
            guestsCount: appartement.guestCount,
            bedroomsCount: appartement.details.bedrooms,
            bedsCount: appartement.details.beds,
            bathroomsCount: appartement.details.bathrooms,
            offers: appartement.details.offers,
            photosData: [],
            imageUrls: appartement.photosStringURL.compactMap { URL(string: $0) },
            title: appartement.title,
            description: appartement.details.description,
            descriptions: appartement.details.descriptionTypes,
            price: appartement.pricePerNight,
            cancellationPolicy: appartement.details.cancellationPolicy
        )
    }
}
