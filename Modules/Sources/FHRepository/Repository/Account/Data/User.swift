//
//  User.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import Foundation

public class User: Codable {
    public let id: String
    public let userName: String
    public let email: String
    public var isHost: Bool
    public var role: UserRole
    public let registrationDate: Date
    public let profilePictureURL: URL?

    public init(
        id: String,
        userName: String,
        email: String,
        isHost: Bool = false,
        role: UserRole = .default,
        registrationDate: Date = Date.now,
        profilePictureURL: URL? = nil
    ) {
        self.id = id
        self.userName = userName
        self.email = email
        self.isHost = isHost
        self.role = role
        self.registrationDate = registrationDate
        self.profilePictureURL = profilePictureURL
    }
}
