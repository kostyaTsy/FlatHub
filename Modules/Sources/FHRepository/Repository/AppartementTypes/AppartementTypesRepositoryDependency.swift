//
//  AppartementTypesRepositoryDependency.swift
//
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import Dependencies

public struct AppartementTypesRepositoryDependency: Sendable {
    public var loadTypes: @Sendable () async throws -> [AppartementType]
    public var loadOffers: @Sendable () async throws -> [AppartementOfferType]
    public var loadLivingTypes: @Sendable () async throws -> [AppartementLivingType]
    public var loadDescriptions: @Sendable () async throws -> [AppartementDescriptionType]
    public var loadCancellationPolicies: @Sendable () async throws -> [AppartementCancellationPolicyType]
}

// MARK: - Live

extension AppartementTypesRepositoryDependency {
    static func live(
        repository: AppartementTypesRepositoryProtocol = AppartementTypesRepository()
    ) -> AppartementTypesRepositoryDependency {
        let dependencyRepository = AppartementTypesRepositoryDependency(
            loadTypes: {
                try await repository.loadTypes()
            },
            loadOffers: {
                try await repository.loadOffers()
            },
            loadLivingTypes: {
                try await repository.loadLivingTypes()
            },
            loadDescriptions: {
                try await repository.loadDescriptions()
            },
            loadCancellationPolicies: {
                try await repository.loadCancellationPolicies()
            }
        )

        return dependencyRepository
    }
}

// MARK: - Preview

extension AppartementTypesRepositoryDependency {
    static func mock() -> AppartementTypesRepositoryDependency {
        let dependencyRepository = AppartementTypesRepositoryDependency(
            loadTypes: {
                [
                    AppartementType(id: 1, name: "Type", iconName: "person"),
                    AppartementType(id: 2, name: "Type", iconName: "person")
                ]
            },
            loadOffers: {
                [
                    AppartementOfferType(id: 1, name: "Offer", iconName: "person"),
                    AppartementOfferType(id: 2, name: "Offer", iconName: "person")
                ]
            },
            loadLivingTypes: {
                [
                    AppartementLivingType(id: 1, title: "Living", description: "Desc", iconName: "person"),
                    AppartementLivingType(id: 2, title: "Living", description: "Desc", iconName: "person")
                ]
            },
            loadDescriptions: {
                [
                    AppartementDescriptionType(id: 1, name: "Desc", iconName: "person"),
                    AppartementDescriptionType(id: 2, name: "Desc", iconName: "person")
                ]
            },
            loadCancellationPolicies: {
                [
                    AppartementCancellationPolicyType(id: 1, title: "Title", hostDescription: "HostDesc", travelDescription: "TravelDesc"),
                    AppartementCancellationPolicyType(id: 2, title: "Title", hostDescription: "HostDesc", travelDescription: "TravelDesc")
                ]
            }
        )

        return dependencyRepository
    }
}

// MARK: - Dependency

extension AppartementTypesRepositoryDependency: DependencyKey {
    public static var liveValue: AppartementTypesRepositoryDependency {
        AppartementTypesRepositoryDependency.live()
    }

    public static var previewValue: AppartementTypesRepositoryDependency {
        AppartementTypesRepositoryDependency.mock()
    }

    public static var testValue: AppartementTypesRepositoryDependency {
        AppartementTypesRepositoryDependency.mock()
    }
}

extension DependencyValues {
    public var appartementTypesRepository: AppartementTypesRepositoryDependency {
        get { self[AppartementTypesRepositoryDependency.self] }
        set { self[AppartementTypesRepositoryDependency.self] = newValue }
    }
}
