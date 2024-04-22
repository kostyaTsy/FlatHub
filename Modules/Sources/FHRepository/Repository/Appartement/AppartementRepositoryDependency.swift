//
//  AppartementRepositoryDependency.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation
import Dependencies

public struct AppartementRepositoryDependency: Sendable {
    public var createAppartement: @Sendable (_ dto: CreateAppartementDTO) async throws -> Void
}

// MARK: - Live

extension AppartementRepositoryDependency {
    static func live(
        appartementRepository: AppartementRepositoryProtocol = AppartementRepository()
    ) -> AppartementRepositoryDependency {
        let dependency = AppartementRepositoryDependency(
            createAppartement: { dto in
                try await appartementRepository.createAppartement(with: dto)
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
