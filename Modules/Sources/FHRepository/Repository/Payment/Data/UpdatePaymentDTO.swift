//
//  UpdatePaymentDTO.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

public struct UpdatePaymentDTO {
    let bookingId: String
    let refundPercentage: Int

    public init(
        bookingId: String,
        refundPercentage: Int
    ) {
        self.bookingId = bookingId
        self.refundPercentage = refundPercentage
    }
}
