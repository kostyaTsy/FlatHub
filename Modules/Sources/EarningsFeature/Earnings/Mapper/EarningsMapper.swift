//
//  EarningsMapper.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation
import FHRepository

enum EarningsMapperError: Error {
    case invalidStartDate
}

enum EarningsMapper {
    static func mapToLoadPaymentDTO(
        for hostUserId: String,
        for date: Date
    ) throws -> LoadPaymentDTO {
        guard let startMonth = date.startOfMonth(),
              let endMonth = date.endOfMonth()
        else {
            throw EarningsMapperError.invalidStartDate
        }
        return LoadPaymentDTO(
            hostUserId: hostUserId,
            startDate: startMonth,
            endDate: endMonth
        )
    }

    static func mapToEarningsModel(
        from payment: PaymentDTO
    ) -> EarningsModel {
        EarningsModel(
            profit: payment.amount - (payment.refund ?? 0),
            profitStartDate: payment.bookStartDate,
            profitEndDate: payment.bookEndDate,
            profitCreateDate: payment.createDate
        )
    }
}
