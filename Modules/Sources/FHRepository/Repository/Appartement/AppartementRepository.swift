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

    func deleteAppartement(with id: String) async throws
    
    func updateAppartementAvailability(
        with dto: AppartementAvailabilityDTO
    ) async throws
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

    public func deleteAppartement(with id: String) async throws {
        async let deleteAppartementRequest: () = deleteAppartementData(with: id)
        async let deleteAppartementInfoRequest: () = deleteAppartementInfo(with: id)

        _ = try await [deleteAppartementRequest, deleteAppartementInfoRequest]
    }

    public func updateAppartementAvailability(
        with dto: AppartementAvailabilityDTO
    ) async throws {
        try await store.collection(DBTableName.appartementTable)
            .document(dto.id)
            .updateData(["isAvailableForBook": dto.isAvailable])
    }
}

// MARK: - Upload

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

// MARK: - Delete

private extension AppartementRepository {
    private func deleteAppartementData(with id: String) async throws {
        try await store.collection(DBTableName.appartementTable)
            .document(id)
            .delete()
    }

    private func deleteAppartementInfo(with id: String) async throws {
        try await store.collection(DBTableName.appartementInfoTable)
            .document(id)
            .delete()
    }
}
