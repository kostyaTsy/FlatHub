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
}

public actor PaymentRepository: PaymentRepositoryProtocol {
    private let store: Firestore

    public init(store: Firestore = Firestore.firestore()) {
        self.store = store
    }

    public func createPayment(_ dto: PaymentDTO) async throws {
        try store.collection(DBTableName.paymentTable)
            .document(dto.id)
            .setData(from: dto)
    }
}
