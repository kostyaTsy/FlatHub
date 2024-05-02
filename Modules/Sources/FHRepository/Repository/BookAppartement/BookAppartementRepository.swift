//
//  BookAppartementRepository.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation
import FirebaseFirestore

public protocol BookAppartementRepositoryProtocol {
    func bookAppartement(_ dto: BookAppartementRequestDTO) async throws
    func loadUserBooks(for userId: String) async throws -> [BookAppartementDTO]
    func loadHostUserBooks(for hostUserId: String) async throws -> [BookAppartementDTO]
    func getBookedDates(for appartementId: String) async throws -> [BookedDates]
}

enum BookAppartementRepositoryError: Error, LocalizedError {
    case invalidDateForBooking

    var errorDescription: String? {
        switch self {
        case .invalidDateForBooking:
            return "Invalid dates for booking"
        }
    }
}

public actor BookAppartementRepository: BookAppartementRepositoryProtocol {
    private let store: Firestore
    private let paymentRepository: PaymentRepositoryProtocol

    public init(
        store: Firestore = Firestore.firestore(),
        paymentRepository: PaymentRepositoryProtocol = PaymentRepository()
    ) {
        self.store = store
        self.paymentRepository = paymentRepository
    }

    public func bookAppartement(_ dto: BookAppartementRequestDTO) async throws {
        guard let canBook = try? await canBookAppartement(dto), canBook else {
            throw BookAppartementRepositoryError.invalidDateForBooking
        }
        let appartement = try await getAppartement(by: dto.appartementId)

        let bookAppartementDTO = BookAppartementMapper.mapToBookAppartement(
            from: dto, with: appartement
        )

        try store.collection(DBTableName.bookAppartementTable)
            .document(dto.documentPath)
            .setData(from: bookAppartementDTO)

        let paymentDTO = BookAppartementMapper.mapToPaymentDTO(
            from: dto, with: appartement
        )
        try await paymentRepository.createPayment(paymentDTO)
    }

    public func loadUserBooks(for userId: String) async throws -> [BookAppartementDTO] {
        try await store.collection(DBTableName.bookAppartementTable)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: BookAppartementDTO.self)
            }
    }

    public func loadHostUserBooks(for hostUserId: String) async throws -> [BookAppartementDTO] {
        try await store.collection(DBTableName.bookAppartementTable)
            .whereField("hostUserId", isEqualTo: hostUserId)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: BookAppartementDTO.self)
            }
    }

    public func getBookedDates(for appartementId: String) async throws -> [BookedDates] {
        let bookedAppartements = try await getBookedAppartements(with: appartementId)
        let bookedDates = bookedAppartements
            .sorted {
                $0.startDate < $1.startDate
            }.map {
                BookedDates(startDate: $0.startDate, endDate: $0.endDate)
            }

        return bookedDates
    }
}

private extension BookAppartementRepository {
    func getAppartement(by id: String) async throws -> AppartementDTO {
        try await store.collection(DBTableName.appartementTable)
            .document(id)
            .getDocument()
            .data(as: AppartementDTO.self)
    }

    func getBookedAppartements(with id: String) async throws -> [BookAppartementDTO] {
        try await store.collection(DBTableName.bookAppartementTable)
            .whereField("appartement.id", isEqualTo: id)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: BookAppartementDTO.self)
            }
    }

    func canBookAppartement(_ dto: BookAppartementRequestDTO) async throws -> Bool {
        let startDateTimestamp = Timestamp(date: dto.startDate)
        let endDateTimestamp = Timestamp(date: dto.endDate)

        let appartements = try await store.collection(DBTableName.bookAppartementTable)
            .whereField("appartement.id", isEqualTo: dto.appartementId)
            .whereField("status", isEqualTo: BookStatus.booked.rawValue)
            .whereField("startDate", isLessThan: endDateTimestamp)
            .whereField("endDate", isGreaterThan: startDateTimestamp)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: BookAppartementDTO.self)
            }

        return appartements.isEmpty
    }
}
