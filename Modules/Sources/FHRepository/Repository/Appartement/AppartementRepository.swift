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

    func addAppartementToFavorite(with dto: FavouriteAppartementRequestDTO) async throws
    func removeAppartementFromFavourite(with dto: FavouriteAppartementRequestDTO) async throws

    func updateAppartementAvailability(
        with dto: AppartementAvailabilityDTO
    ) async throws

    func updateAppartementRatings(_ dto: UpdateAppartementRatingDTO) async throws

    func loadHostAppartements(for userId: String) async throws -> [AppartementDetailsDTO]
    func loadAppartements(for userId: String) async throws -> [ExploreAppartementDTO]
    func searchAppartements(
        for userId: String,
        with searchDTO: AppartementSearchDTO
    ) async throws -> [ExploreAppartementDTO]

    func loadFavouriteAppartements(for userId: String) async throws -> [ExploreAppartementDTO]
    func loadAppartementInfo(for appartementId: String) async throws -> AppartementInfoDTO
}

public actor AppartementRepository: AppartementRepositoryProtocol {
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

    public func addAppartementToFavorite(with dto: FavouriteAppartementRequestDTO) async throws {
        try store.collection(DBTableName.favouriteAppartementTable)
            .document(dto.documentId)
            .setData(from: dto)
    }

    public func removeAppartementFromFavourite(with dto: FavouriteAppartementRequestDTO) async throws {
        try await store.collection(DBTableName.favouriteAppartementTable)
            .document(dto.documentId)
            .delete()
    }

    public func updateAppartementAvailability(
        with dto: AppartementAvailabilityDTO
    ) async throws {
        try await store.collection(DBTableName.appartementTable)
            .document(dto.id)
            .updateData(["isAvailableForBook": dto.isAvailable])
    }

    public func updateAppartementRatings(_ dto: UpdateAppartementRatingDTO) async throws {
        try await store.collection(DBTableName.appartementTable)
            .document(dto.appartementId)
            .updateData([
                "reviewCount": dto.reviewCount,
                "rating": dto.rating
            ])
    }

    public func loadHostAppartements(for userId: String) async throws -> [AppartementDetailsDTO] {
        let appartements = try await loadHostAppartementsData(for: userId)
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

    public func loadAppartements(for userId: String) async throws -> [ExploreAppartementDTO] {
        async let appartementsRequest = loadExploreAppartementsData()
        async let favouriteAppartementsRequest = loadFavouriteAppartementsData(for: userId)

        let result = try await (appartementsRequest, favouriteAppartementsRequest)

        let appartements = result.0
        let favouriteAppartements = result.1

        return appartements.map { appartement in
            let favouriteAppartement = favouriteAppartements.first(where: { $0.appartementId == appartement.id })
            return AppartementMapper.mapToExploreAppartementDTO(
                from: appartement,
                isFavourite: favouriteAppartement != nil
            )
        }
    }

    public func searchAppartements(
        for userId: String,
        with searchDTO: AppartementSearchDTO
    ) async throws -> [ExploreAppartementDTO] {
        async let appartementsRequest = searchAppartementsData(with: searchDTO)
        async let favouriteAppartementsRequest = loadFavouriteAppartementsData(for: userId)
        async let bookedAppartementsRequest = loadBookedAppartementsData(
            startDate: searchDTO.startDate,
            endDate: searchDTO.endDate
        )

        let result = try await (appartementsRequest, favouriteAppartementsRequest, bookedAppartementsRequest)

        let appartements = result.0
        let favouriteAppartements = result.1
        let bookedAppartements = result.2

        return appartements
            .filter { appartement in
                let bookedAppartement = bookedAppartements.first(where: { $0.appartement.id == appartement.id })
                return bookedAppartement == nil
            }
            .map { appartement in
                let favouriteAppartement = favouriteAppartements.first(where: { $0.appartementId == appartement.id })
                return AppartementMapper.mapToExploreAppartementDTO(
                    from: appartement,
                    isFavourite: favouriteAppartement != nil
                )
            }
    }

    public func loadFavouriteAppartements(for userId: String) async throws -> [ExploreAppartementDTO] {
        let favoriteAppartements = try await loadFavouriteAppartementsWithAppartement(for: userId)
        return favoriteAppartements.map {
            AppartementMapper.mapToExploreAppartementDTO(
                from: $0.appartement, isFavourite: true
            )
        }
    }

    public func loadAppartementInfo(for appartementId: String) async throws -> AppartementInfoDTO {
        try await store.collection(DBTableName.appartementInfoTable)
            .document(appartementId)
            .getDocument()
            .data(as: AppartementInfoDTO.self)
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
    func getAppartement(by id: String) async throws -> AppartementDTO {
        try await store.collection(DBTableName.appartementTable)
            .document(id)
            .getDocument()
            .data(as: AppartementDTO.self)
    }

    func loadHostAppartementsData(for userId: String) async throws -> [AppartementDTO] {
        try await store.collection(DBTableName.appartementTable)
            .whereField("hostUserId", isEqualTo: userId)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: AppartementDTO.self)
            }
    }

    func loadExploreAppartementsData() async throws -> [AppartementDTO] {
        try await store.collection(DBTableName.appartementTable)
            .whereField("isAvailableForBook", isEqualTo: true)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: AppartementDTO.self)
            }
    }

    func searchAppartementsData(with searchDTO: AppartementSearchDTO) async throws -> [AppartementDTO] {
        try await store.collection(DBTableName.appartementTable)
            .whereField("isAvailableForBook", isEqualTo: true)
            .whereField("city", isEqualTo: searchDTO.city)
            .whereField("guestCount", isGreaterThanOrEqualTo: searchDTO.guestsCount)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: AppartementDTO.self)
            }
    }

    func loadBookedAppartementsData(startDate: Date, endDate: Date) async throws -> [BookAppartementDTO] {
        let startDateTimestamp = Timestamp(date: startDate)
        let endDateTimestamp = Timestamp(date: endDate)

        return try await store.collection(DBTableName.bookAppartementTable)
            .whereField("status", isEqualTo: BookStatus.booked.rawValue)
            .whereField("startDate", isLessThan: endDateTimestamp)
            .whereField("endDate", isGreaterThan: startDateTimestamp)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: BookAppartementDTO.self)
            }
    }

    func loadFavouriteAppartementsData(for userId: String) async throws -> [FavouriteAppartementResponseDTO] {
        return try await store.collection(DBTableName.favouriteAppartementTable)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: FavouriteAppartementResponseDTO.self)
            }
    }

    func loadFavouriteAppartementsWithAppartement(for userId: String) async throws -> [FavouriteAppartementDTO] {
        let favoriteAppartementsResponse = try await loadFavouriteAppartementsData(for: userId)
        return try await withThrowingTaskGroup(
            of: AppartementDTO.self,
            returning: [FavouriteAppartementDTO].self
        ) { taskGroup in
            for appartement in favoriteAppartementsResponse {
                taskGroup.addTask { try await self.getAppartement(by: appartement.appartementId) }
            }

            var favouritesDTO: [FavouriteAppartementDTO] = []
            for try await result in taskGroup {
                let favouriteDTO = AppartementMapper.mapToFavouriteAppartementDTO(
                    with: userId, appartement: result
                )
                favouritesDTO.append(favouriteDTO)
            }

            return favouritesDTO
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
}
