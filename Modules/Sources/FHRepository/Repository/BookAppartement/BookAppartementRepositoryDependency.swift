//
//  BookAppartementRepositoryDependency.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Dependencies

public struct BookAppartementRepositoryDependency: Sendable {
    public var bookAppartement: @Sendable (_ dto: BookAppartementRequestDTO) async throws -> Void
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
