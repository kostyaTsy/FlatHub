//
//  AppartementRepository.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import Foundation
import FirebaseFirestore

public protocol AppartementRepositoryProtocol {
    func createAppartement(
        with dto: CreateAppartementDTO
    ) async throws -> AppartementDetailsDTO
}

public final class AppartementRepository: AppartementRepositoryProtocol {
    private let store: Firestore

    public init(store: Firestore = Firestore.firestore()) {
        self.store = store
    }

    public func createAppartement(
        with dto: CreateAppartementDTO
    ) async throws -> AppartementDetailsDTO {
        let appartementDTO = AppartementMapper.mapToAppartementDTO(from: dto)
        let appartementInfoDTO = AppartementMapper.mapToAppartementInfoDTO(from: dto)
        async let uploadAppartement: () = uploadAppartement(with: appartementDTO)
        async let uploadAppartementInfo: () = uploadAppartementInfo(with: appartementInfoDTO)

        _ = try await [uploadAppartement, uploadAppartementInfo]

        return AppartementMapper.mapToAppartementDetailsDTO(from: dto)
    }
}

private extension AppartementRepository {
    private func uploadAppartement(with dto: AppartementDTO) async throws {
        try store.collection(DBTableName.appartementTable)
            .document(dto.id)
            .setData(from: dto)
    }

    private func uploadAppartementInfo(with dto: AppartementInfoDTO) async throws {
        try store.collection(DBTableName.appartementInfoTable)
            .document(dto.appartementId)
            .setData(from: dto)
    }
}
