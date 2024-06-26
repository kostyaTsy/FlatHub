//
//  BookAppartementDTO.swift
//
//
//  Created by Kostya Tsyvilko on 29.04.24.
//

import Foundation

public enum BookStatus: String, Codable {
    case booked

    /// Indicated that booking period passed
    case done
    case cancelled
}

public struct BookAppartementDTO: Codable {
    public let id: String
    public let userId: String
    public let hostUserId: String
    public let startDate: Date
    public let endDate: Date
    public let bookDate: Date
    public let status: String
    public let appartement: AppartementDTO

    init(
        id: String = UUID().uuidString,
        userId: String,
        hostUserId: String,
        startDate: Date,
        endDate: Date,
        bookDate: Date,
        status: BookStatus,
        appartement: AppartementDTO
    ) {
        self.id = id
        self.userId = userId
        self.hostUserId = hostUserId
        self.startDate = startDate
        self.endDate = endDate
        self.bookDate = bookDate
        self.status = status.rawValue
        self.appartement = appartement
    }
}
