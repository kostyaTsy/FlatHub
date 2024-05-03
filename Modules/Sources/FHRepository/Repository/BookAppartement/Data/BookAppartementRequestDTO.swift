//
//  BookAppartementRequestDTO.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

public struct BookAppartementRequestDTO: Codable {
    public let id: String
    public let userId: String
    public let hostUserId: String
    public let appartementId: String
    public let startDate: Date
    public let endDate: Date

    public init(
        id: String = UUID().uuidString,
        userId: String,
        hostUserId: String,
        appartementId: String,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.userId = userId
        self.hostUserId = hostUserId
        self.appartementId = appartementId
        self.startDate = startDate
        self.endDate = endDate
    }
}
