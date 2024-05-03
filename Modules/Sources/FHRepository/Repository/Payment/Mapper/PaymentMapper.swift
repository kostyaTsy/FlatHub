//
//  PaymentMapper.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

enum PaymentMapper {
    static func mapToPaymentDTO(
        from payment: PaymentDTO,
        with refundPercentage: Int
    ) -> PaymentDTO {
        PaymentDTO(
            bookingId: payment.bookingId,
            userId: payment.userId,
            hostUserId: payment.hostUserId,
            appartementId: payment.appartementId,
            amount: payment.amount,
            refund: Int(payment.amount * refundPercentage / 100),
            bookStartDate: payment.bookStartDate,
            bookEndDate: payment.bookEndDate,
            createDate: payment.createDate
        )
    }
}
