//
//  AppartementRepositoryDependency.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation
import Dependencies

public struct AppartementRepositoryDependency: Sendable {
    public var createAppartement: @Sendable (_ dto: CreateAppartementDTO) async throws -> AppartementDetailsDTO
    public var deleteAppartement: @Sendable (_ id: String) async throws -> Void
    public var updateAppartementAvailability: @Sendable (_ dto: AppartementAvailabilityDTO) async throws -> Void

}

// MARK: - Live

extension AppartementRepositoryDependency {
    static func live(
        appartementRepository: AppartementRepositoryProtocol = AppartementRepository()
    ) -> AppartementRepositoryDependency {
        let dependency = AppartementRepositoryDependency(
            createAppartement: { dto in
                try await appartementRepository.createAppartement(with: dto)
            }, deleteAppartement: { id in
                try await appartementRepository.deleteAppartement(with: id)
            }, updateAppartementAvailability: { dto in
                try await appartementRepository.updateAppartementAvailability(with: dto)
            }
        )

        return dependency
    }
}

// MARK: - mock

extension AppartementRepositoryDependency {
    static func mock() -> AppartementRepositoryDependency {
        let mockDependency = AppartementRepositoryDependency(
            createAppartement: { _ in
                AppartementDetailsDTO(
                    id: "id",
                    hostUserId: "",
                    title: "title",
                    city: "city",
                    country: "county",
                    countryCode: "countyCode",
                    pricePerNight: 12,
                    guestCount: 3,
                    photosStringURL: [],
                    createDate: Date.now,
                    info: .init(
                        appartementId: "id",
                        latitude: 12,
                        longitude: 12,
                        description: "description",
                        bedrooms: 1,
                        beds: 1,
                        bathrooms: 1,
                        type: .init(id: 1, name: "name", iconName: "person"),
                        livingType: .init(id: 1, title: "title", description: "description", iconName: "person"),
                        offers: [],
                        descriptionTypes: [],
                        cancellationPolicy: .init(id: 1, title: "", hostDescription: "", travelDescription: "")
                    )
                )
            }, deleteAppartement: { _ in
                ()
            }, updateAppartementAvailability: { _ in
                ()
            }
        )

        return mockDependency
    }
}

// MARK: - Dependency

extension AppartementRepositoryDependency: DependencyKey {
    public static var liveValue: AppartementRepositoryDependency {
        AppartementRepositoryDependency.live()
    }

    public static var previewValue: AppartementRepositoryDependency {
        AppartementRepositoryDependency.mock()
    }

    public static var testValue: AppartementRepositoryDependency {
        AppartementRepositoryDependency.mock()
    }
}

extension DependencyValues {
    public var appartementRepository: AppartementRepositoryDependency {
        get { self[AppartementRepositoryDependency.self] }
        set { self[AppartementRepositoryDependency.self] = newValue }
    }
}
