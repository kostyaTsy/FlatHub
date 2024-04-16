//
//  AppartementTypesRepository.swift
//
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import Foundation
import FirebaseFirestore

public protocol AppartementTypesRepositoryProtocol {
    func loadTypes() async throws -> [AppartementType]
    func loadOffers() async throws -> [AppartementOfferType]
    func loadLivingTypes() async throws -> [AppartementLivingType]
    func loadDescriptions() async throws -> [AppartementDescriptionType]
    func loadCancellationPolicies() async throws -> [AppartementCancellationPolicyType]
}

final public class AppartementTypesRepository: AppartementTypesRepositoryProtocol {
    private let store: Firestore

    public init(store: Firestore = Firestore.firestore()) {
        self.store = store
    }

    public func loadTypes() async throws -> [AppartementType] {
        return try await load(for: DBTableName.appartementTypeTable)
    }
    
    public func loadOffers() async throws -> [AppartementOfferType] {
        return try await load(for: DBTableName.appartementOfferTypeTable)
    }
    
    public func loadLivingTypes() async throws -> [AppartementLivingType] {
        return try await load(for: DBTableName.appartementLivingTypeTable)
    }
    
    public func loadDescriptions() async throws -> [AppartementDescriptionType] {
        return try await load(for: DBTableName.appartementDescriptionTypeTable)
    }
    
    public func loadCancellationPolicies() async throws -> [AppartementCancellationPolicyType] {
        return try await load(for: DBTableName.appartementCancellationPolicyTypeTable)
    }
}

private extension AppartementTypesRepository {
    func load<T: Codable>(for tableName: String) async throws -> [T] {
        try await store.collection(tableName)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: T.self)
            }
    }
}
