//
//  ReviewRepositoryDependency.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Dependencies

public struct ReviewRepositoryDependency: Sendable {
    public var addReview: @Sendable (_ dto: ReviewRequestDTO) async throws -> Void
    public var getUserReviews: @Sendable (_ userId: String) async throws -> [UserReviewModel]
    public var getAppartementReviews: @Sendable (_ appartementId: String) async throws -> [AppartementReviewModel]
}

// MARK: - Live

extension ReviewRepositoryDependency {
    static func live(
        repository: ReviewRepositoryProtocol = ReviewRepository()
    ) -> ReviewRepositoryDependency {
        let dependency = ReviewRepositoryDependency(
            addReview: { dto in
                try await repository.addReview(dto)
            }, getUserReviews: { userId in
                try await repository.getUserReviews(for: userId)
            }, getAppartementReviews: { appartementId in
                try await repository.getAppartementReviews(for: appartementId)
            }
        )

        return dependency
    }
}

// MARK: - Preview

extension ReviewRepositoryDependency {
    static func mock() -> ReviewRepositoryDependency {
        let dependency = ReviewRepositoryDependency(
            addReview: { _ in
                ()
            }, getUserReviews: { _ in
                []
            }, getAppartementReviews: { _ in
                []
            }
        )

        return dependency
    }
}

// MARK: - Dependency

extension ReviewRepositoryDependency: DependencyKey {
    public static var liveValue: ReviewRepositoryDependency {
        ReviewRepositoryDependency.live()
    }

    public static var previewValue: ReviewRepositoryDependency {
        ReviewRepositoryDependency.mock()
    }

    public static var testValue: ReviewRepositoryDependency {
        ReviewRepositoryDependency.mock()
    }
}

extension DependencyValues {
    public var reviewRepository: ReviewRepositoryDependency {
        get { self[ReviewRepositoryDependency.self] }
        set { self[ReviewRepositoryDependency.self] = newValue }
    }
}
