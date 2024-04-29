//
//  BookAppartementDTO.swift
//
//
//  Created by Kostya Tsyvilko on 29.04.24.
//

import Foundation

public struct BookAppartementDTO: Codable {
    public let userId: String
    public let hostUserId: String
    public let startDate: Date
    public let endDate: Date
    public let appartement: AppartementDTO

    init(
        userId: String,
        hostUserId: String,
        startDate: Date,
        endDate: Date,
        appartement: AppartementDTO
    ) {
        self.userId = userId
        self.hostUserId = hostUserId
        self.startDate = startDate
        self.endDate = endDate
        self.appartement = appartement
    }
}
