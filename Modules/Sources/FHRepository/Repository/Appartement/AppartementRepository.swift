//
//  AppartementRepository.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import Foundation
import FirebaseFirestore

public protocol AppartementRepositoryProtocol {
    func createAppartement(with dto: CreateAppartementDTO) async throws
}

public final class AppartementRepository: AppartementRepositoryProtocol {
    private let store: Firestore

    public init(store: Firestore = Firestore.firestore()) {
        self.store = store
    }

    public func createAppartement(with dto: CreateAppartementDTO) async throws {
        let appartementDTO = AppartementMapper.mapToAppartementDTO(from: dto)
        let appartementInfoDTO = AppartementMapper.mapToAppartementInfoDTO(from: dto)
        async let uploadAppartement: () = uploadAppartement(with: appartementDTO)
        async let uploadAppartementInfo: () = uploadAppartementInfo(with: appartementInfoDTO)

        _ = try await [uploadAppartement, uploadAppartementInfo]
    }

    public func uploadAppartement(with dto: AppartementDTO) async throws {
        try store.collection(DBTableName.appartementTable)
            .document(dto.id)
            .setData(from: dto)
    }

    public func uploadAppartementInfo(with dto: AppartementInfoDTO) async throws {
        try store.collection(DBTableName.appartementInfoTable)
            .document(dto.appartementId)
            .setData(from: dto)
    }
}
