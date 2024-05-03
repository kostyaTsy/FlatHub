//
//  ReviewRepository.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation
import FirebaseFirestore

public protocol ReviewRepositoryProtocol {
    func addReview(_ dto: ReviewRequestDTO) async throws
    func getUserReviews(for userId: String) async throws -> [UserReviewModel]
    func getAppartementReviews(for appartementId: String) async throws -> [AppartementReviewModel]
}

public actor ReviewRepository: ReviewRepositoryProtocol {
    private let store: Firestore
    private let userRepository: UserRepositoryProtocol
    private let appartementRepository: AppartementRepositoryProtocol

    public init(
        store: Firestore = Firestore.firestore(),
        userRepository: UserRepositoryProtocol = UserRepository(),
        appartementRepository: AppartementRepositoryProtocol = AppartementRepository()
    ) {
        self.store = store
        self.userRepository = userRepository
        self.appartementRepository = appartementRepository
    }

    public func addReview(_ dto: ReviewRequestDTO) async throws {
        async let userReviewRequest: () = addReviewToUser(dto)
        async let appartementReviewRequest: () = addReviewToAppartement(dto)

        _ = try await [userReviewRequest, appartementReviewRequest]
        try await updateAppartementRatings(for: dto.appartementId)
    }

    public func getUserReviews(for userId: String) async throws -> [UserReviewModel] {
        let reviewsData = try await getUserReviewsData(for: userId)

        return try await withThrowingTaskGroup(
            of: (UserReviewResponseDTO, UserModel, UserModel).self,
            returning: [UserReviewModel].self
        ) { taskGroup in
            for data in reviewsData {
                taskGroup.addTask { [self] in
                    (
                        data,
                        try await self.userRepository.load(userId: data.userIdToReview),
                        try await self.userRepository.load(userId: data.userIdByReview)
                    )
                }
            }

            var reviews: [UserReviewModel] = []
            for try await result in taskGroup {
                let review = ReviewMapper.mapToUserReviewModel(
                    from: result.0,
                    userToReview: result.1,
                    userByReview: result.2
                )
                reviews.append(review)
            }

            return reviews
        }
    }

    public func getAppartementReviews(for appartementId: String) async throws -> [AppartementReviewModel] {
        let reviewsData = try await getAppartementReviewsData(for: appartementId)

        return try await withThrowingTaskGroup(
            of: (AppartementReviewResponseDTO, UserModel).self,
            returning: [AppartementReviewModel].self
        ) { taskGroup in
            for data in reviewsData {
                taskGroup.addTask { [self] in
                    (
                        data,
                        try await self.userRepository.load(userId: data.userId)
                    )
                }
            }

            var reviews: [AppartementReviewModel] = []
            for try await result in taskGroup {
                let review = ReviewMapper.mapToAppartementReviewModel(
                    from: result.0, user: result.1
                )
                reviews.append(review)
            }

            return reviews
        }
    }
}

private extension ReviewRepository {
    func addReviewToUser(_ dto: ReviewRequestDTO) async throws {
        let userReviewDTO = ReviewMapper.mapToUserReviewDTO(from: dto)

        try store.collection(DBTableName.userReviewTable)
            .document(userReviewDTO.id) 
            .setData(from: userReviewDTO)
    }

    func addReviewToAppartement(_ dto: ReviewRequestDTO) async throws {
        let appartementReviewDTO = ReviewMapper.mapToAppartementReviewDTO(from: dto)

        try store.collection(DBTableName.appartementReviewTable)
            .document(appartementReviewDTO.id)
            .setData(from: appartementReviewDTO)
    }

    func getUserReviewsData(for userId: String) async throws -> [UserReviewResponseDTO] {
        try await store.collection(DBTableName.userReviewTable)
            .whereField("userIdToReview", isEqualTo: userId)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: UserReviewResponseDTO.self)
            }
    }

    func getAppartementReviewsData(for appartementId: String) async throws -> [AppartementReviewResponseDTO] {
        try await store.collection(DBTableName.appartementReviewTable)
            .whereField("appartementId", isEqualTo: appartementId)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: AppartementReviewResponseDTO.self)
            }
    }

    func updateAppartementRatings(for appartementId: String) async throws {
        let reviews = try await getAppartementReviewsData(for: appartementId)

        let reviewCount = reviews.count
        let averageRating = reviews.reduce(0.0) { $0 + Double($1.rating) } / Double(reviewCount)
        let updateDTO = ReviewMapper.mapToUpdateAppartementRatingDTO(
            appartementId: appartementId,
            averageRating: averageRating,
            reviewCount: reviewCount
        )

        try await appartementRepository.updateAppartementRatings(updateDTO)
    }
}
