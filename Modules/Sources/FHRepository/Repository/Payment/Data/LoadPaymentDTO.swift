//
//  LoadPaymentDTO.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

public struct LoadPaymentDTO {
    let hostUserId: String
    let startDate: Date
    let endDate: Date

    public init(
        hostUserId: String,
        startDate: Date,
        endDate: Date
    ) {
        self.hostUserId = hostUserId
        self.startDate = startDate
        self.endDate = endDate
    }
}
