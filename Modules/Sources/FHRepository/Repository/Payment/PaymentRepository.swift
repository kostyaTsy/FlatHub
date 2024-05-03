//
//  PaymentRepository.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation
import FirebaseFirestore

public protocol PaymentRepositoryProtocol {
    func createPayment(_ dto: PaymentDTO) async throws
    func updatePayment(_ dto: UpdatePaymentDTO) async throws
    func loadPayments(_ dto: LoadPaymentDTO) async throws -> [PaymentDTO]
}

public actor PaymentRepository: PaymentRepositoryProtocol {
    private let store: Firestore

    public init(store: Firestore = Firestore.firestore()) {
        self.store = store
    }

    public func createPayment(_ dto: PaymentDTO) async throws {
        try store.collection(DBTableName.paymentTable)
            .document(dto.bookingId)
            .setData(from: dto)
    }

    public func updatePayment(_ dto: UpdatePaymentDTO) async throws {
        let payment = try await getPayment(for: dto.bookingId)
        let updatedPayment = PaymentMapper.mapToPaymentDTO(
            from: payment,
            with: dto.refundPercentage
        )

        try store.collection(DBTableName.paymentTable)
            .document(updatedPayment.bookingId)
            .setData(from: updatedPayment)
    }

    public func loadPayments(_ dto: LoadPaymentDTO) async throws -> [PaymentDTO] {
        let startTimestamp = Timestamp(date: dto.startDate)
        let endTimestamp = Timestamp(date: dto.endDate)

        return try await store.collection(DBTableName.paymentTable)
            .whereField("hostUserId", isEqualTo: dto.hostUserId)
            .whereField("createDate", isGreaterThan: startTimestamp)
            .whereField("createDate", isLessThan: endTimestamp)
            .getDocuments()
            .documents
            .compactMap { snapshot in
                try? snapshot.data(as: PaymentDTO.self)
            }
    }
}

private extension PaymentRepository {
    func getPayment(for id: String) async throws -> PaymentDTO {
        try await store.collection(DBTableName.paymentTable)
            .document(id)
            .getDocument()
            .data(as: PaymentDTO.self)
    }
}
