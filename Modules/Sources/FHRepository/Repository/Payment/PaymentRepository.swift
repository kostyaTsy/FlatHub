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
}

private extension PaymentRepository {
    func getPayment(for id: String) async throws -> PaymentDTO {
        try await store.collection(DBTableName.paymentTable)
            .document(id)
            .getDocument()
            .data(as: PaymentDTO.self)
    }
}
