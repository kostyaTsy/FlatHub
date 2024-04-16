//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import Dependencies

public struct AppartementTypesRepositoryDependency: Sendable {
    var loadTypes: @Sendable () async throws -> [AppartementType]
    var loadOffers: @Sendable () async throws -> [AppartementOfferType]
    var loadLivingTypes: @Sendable () async throws -> [AppartementLivingType]
    var loadDescriptions: @Sendable () async throws -> [AppartementDescriptionType]
    var loadCancellationPolicies: @Sendable () async throws -> [AppartementCancellationPolicyType]
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

// MARK: - Dependency

extension AppartementTypesRepositoryDependency: DependencyKey {
    public static var liveValue: AppartementTypesRepositoryDependency {
        AppartementTypesRepositoryDependency.live()
    }
}

extension DependencyValues {
    public var appartementTypesRepostory: AppartementTypesRepositoryDependency {
        get { self[AppartementTypesRepositoryDependency.self] }
        set { self[AppartementTypesRepositoryDependency.self] = newValue }
    }
}
