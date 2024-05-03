//
//  BookAppartementRepositoryDependency.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Dependencies

public struct BookAppartementRepositoryDependency: Sendable {
    public var bookAppartement: @Sendable (_ dto: BookAppartementRequestDTO) async throws -> Void
    public var cancelBooking: @Sendable (_ dto: CancelBookingDTO) async throws -> Void

    public var loadUserBooks: @Sendable (_ userId: String) async throws -> [BookAppartementDTO]
    public var loadHostUserBooks: @Sendable (_ hostUserId: String) async throws -> [BookAppartementDTO]
    public var getBookedDates: @Sendable (_ appartementId: String) async throws -> [BookedDates]
}

// MARK: - Live

extension BookAppartementRepositoryDependency {
    static func live(
        repository: BookAppartementRepositoryProtocol = BookAppartementRepository()
    ) -> BookAppartementRepositoryDependency {
        let dependencyRepository = BookAppartementRepositoryDependency(
            bookAppartement: { dto in
                try await repository.bookAppartement(dto)
            }, cancelBooking: { dto in
                try await repository.cancelBooking(dto)
            }, loadUserBooks: { userId in
                try await repository.loadUserBooks(for: userId)
            }, loadHostUserBooks: { hostUserId in
                try await repository.loadHostUserBooks(for: hostUserId)
            }, getBookedDates: { appartementId in
                try await repository.getBookedDates(for: appartementId)
            }
        )

        return dependencyRepository
    }
}

// MARK: - Preview

extension BookAppartementRepositoryDependency {
    static func mock() -> BookAppartementRepositoryDependency {
        let dependencyRepository = BookAppartementRepositoryDependency(
            bookAppartement: { _ in
                ()
            }, cancelBooking: { _ in
                ()
            }, loadUserBooks: { _ in
                []
            }, loadHostUserBooks: { _ in
                []
            }, getBookedDates: { _ in
                []
            }
        )

        return dependencyRepository
    }
}

// MARK: - Dependency

extension BookAppartementRepositoryDependency: DependencyKey {
    public static var liveValue: BookAppartementRepositoryDependency {
        BookAppartementRepositoryDependency.live()
    }

    public static var previewValue: BookAppartementRepositoryDependency {
        BookAppartementRepositoryDependency.mock()
    }

    public static var testValue: BookAppartementRepositoryDependency {
        BookAppartementRepositoryDependency.mock()
    }
}

extension DependencyValues {
    public var bookAppartementRepository: BookAppartementRepositoryDependency {
        get { self[BookAppartementRepositoryDependency.self] }
        set { self[BookAppartementRepositoryDependency.self] = newValue }
    }
}
