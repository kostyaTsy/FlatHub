//
//  PaymentDTO.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

public struct PaymentDTO: Codable {
    public let id: String
    public let userId: String
    public let hostUserId: String
    public let appartementId: String
    public let amount: Int
    public let refund: Int?
    public let bookStartDate: Date
    public let bookEndDate: Date
    public let createDate: Date

    public init(
        id: String = UUID().uuidString,
        userId: String,
        hostUserId: String,
        appartementId: String,
        amount: Int,
        refund: Int? = nil,
        bookStartDate: Date,
        bookEndDate: Date,
        createDate: Date = Date.now
    ) {
        self.id = id
        self.userId = userId
        self.hostUserId = hostUserId
        self.appartementId = appartementId
        self.amount = amount
        self.refund = refund
        self.bookStartDate = bookStartDate
        self.bookEndDate = bookEndDate
        self.createDate = createDate
    }
}
