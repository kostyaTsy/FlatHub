//
//  PaymentRepositoryDependency.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Dependencies

public struct PaymentRepositoryDependency: Sendable {
    public var loadPayments: @Sendable (_ dto: LoadPaymentDTO) async throws -> [PaymentDTO]
}

// MARK: - Live

extension PaymentRepositoryDependency {
    static func live(
        repository: PaymentRepositoryProtocol = PaymentRepository()
    ) -> PaymentRepositoryDependency {
        let dependency = PaymentRepositoryDependency(
            loadPayments: { dto in
                try await repository.loadPayments(dto)
            }
        )

        return dependency
    }
}

// MARK: - Preview

extension PaymentRepositoryDependency {
    static func mock() -> PaymentRepositoryDependency {
        let dependency = PaymentRepositoryDependency(
            loadPayments: { _ in
                []
            }
        )

        return dependency
    }
}

// MARK: - Dependency

extension PaymentRepositoryDependency: DependencyKey {
    public static var liveValue: PaymentRepositoryDependency {
        PaymentRepositoryDependency.live()
    }

    public static var previewValue: PaymentRepositoryDependency {
        PaymentRepositoryDependency.mock()
    }

    public static var testValue: PaymentRepositoryDependency {
        PaymentRepositoryDependency.mock()
    }
}

extension DependencyValues {
    public var paymentRepository: PaymentRepositoryDependency {
        get { self[PaymentRepositoryDependency.self] }
        set { self[PaymentRepositoryDependency.self] = newValue }
    }
}
