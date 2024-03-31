//
//  User.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import Foundation

public struct User: Codable {
    let id: String
    let userName: String
    let email: String
    let isHost: Bool
    let registrationDate: Date
    let profilePictureURL: URL?

    public init(
        id: String,
        userName: String,
        email: String,
        isHost: Bool = false,
        registrationDate: Date = Date.now,
        profilePictureURL: URL? = nil
    ) {
        self.id = id
        self.userName = userName
        self.email = email
        self.isHost = isHost
        self.registrationDate = registrationDate
        self.profilePictureURL = profilePictureURL
    }
}
