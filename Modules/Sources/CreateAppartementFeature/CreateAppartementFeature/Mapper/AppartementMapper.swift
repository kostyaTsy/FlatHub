//
//  AppartementMapper.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation
import FHRepository

enum AppartementMapperError: Error {
    case invalidAppartementData
}

enum AppartementMapper {
    static func mapToCreateDTO(
        from: CreateAppartement,
        userId: String
    ) throws -> CreateAppartementDTO {
        guard let title = from.title,
              let description = from.description,
              let city = from.city,
              let country = from.country,
              let countryCode = from.countryCode,
              let price = from.price,
              let longitude = from.longitude,
              let latitude = from.latitude,
              let type = from.type,
              let livingType = from.livingType,
              let cancellationPolicy = from.cancellationPolicy
        else {
            throw AppartementMapperError.invalidAppartementData
        }

        return CreateAppartementDTO(
            id: from.id,
            hostUserId: userId,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            city: city,
            county: country,
            countryCode: countryCode,
            pricePerNight: price,
            guestsCount: from.guestsCount,
            photosStringURL: from.imageUrls.map { $0.absoluteString },
            longitude: longitude,
            latitude: latitude,
            bedrooms: from.bedroomsCount,
            bathrooms: from.bathroomsCount,
            beds: from.bedsCount,
            type: type,
            livingType: livingType,
            offers: from.offers,
            descriptionTypes: from.descriptions,
            cancellationPolicy: cancellationPolicy
        )
    }
}
