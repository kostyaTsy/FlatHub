//
//  ListingsMapper.swift
//
//
//  Created by Kostya Tsyvilko on 24.04.24.
//

import Foundation
import AppartementListFeature
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
}
