//
//  UserModel.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import Foundation

public struct UserModel: Codable {
    public let id: String
    public let userName: String
    public let email: String
    public let isHost: Bool
    public let registrationDate: Date
    public let profilePictureURL: URL?

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
