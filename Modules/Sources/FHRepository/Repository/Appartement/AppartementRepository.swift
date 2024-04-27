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

    func loadHostAppartements(for userId: String) async throws -> [AppartementDetailsDTO]
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

    public func loadHostAppartements(for userId: String) async throws -> [AppartementDetailsDTO] {
        let appartements = try await loadAppartementsData(for: userId)
        let ids = appartements.map { $0.id }

        let infos = try await loadAppartementInfos(for: ids)

        return appartements.compactMap { appartement in
            guard let info = infos[appartement.id] else {
                return nil
            }
            return AppartementMapper.mapToAppartementDetailsDTO(
                from: appartement,
                with: info
            )
        }

    }
}

// MARK: - Upload

private extension AppartementRepository {
    func uploadAppartement(with dto: AppartementDTO) async throws {
        try store.collection(DBTableName.appartementTable)
            .document(dto.id)
            .setData(from: dto)
    }

    func uploadAppartementInfo(with dto: AppartementInfoDTO) async throws {
        try store.collection(DBTableName.appartementInfoTable)
            .document(dto.appartementId)
            .setData(from: dto)
    }
}

// MARK: - Delete

private extension AppartementRepository {
    func deleteAppartementData(with id: String) async throws {
        try await store.collection(DBTableName.appartementTable)
            .document(id)
            .delete()
    }

    func deleteAppartementInfo(with id: String) async throws {
        try await store.collection(DBTableName.appartementInfoTable)
            .document(id)
            .delete()
    }
}

// MARK: - Load

private extension AppartementRepository {
    func loadAppartementsData(for userId: String) async throws -> [AppartementDTO] {
        try await store.collection(DBTableName.appartementTable)
            .whereField("hostUserId", isEqualTo: userId)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: AppartementDTO.self)
            }
    }

    func loadAppartementInfos(for ids: [String]) async throws -> [String: AppartementInfoDTO] {
        try await withThrowingTaskGroup(of: (String, AppartementInfoDTO).self) { taskGroup in
            for id in ids {
                taskGroup.addTask { (id, try await self.loadAppartementInfo(for: id)) }
            }

            var appartementInfos: [String: AppartementInfoDTO] = [:]
            for try await item in taskGroup {
                let id = item.0
                let info = item.1
                appartementInfos[id] = info
            }

            return appartementInfos
        }
    }

    func loadAppartementInfo(for appartementId: String) async throws -> AppartementInfoDTO {
        try await store.collection(DBTableName.appartementInfoTable)
            .document(appartementId)
            .getDocument()
            .data(as: AppartementInfoDTO.self)
    }
}
