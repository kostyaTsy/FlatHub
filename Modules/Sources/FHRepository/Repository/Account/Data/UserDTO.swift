//
//  UserDTO.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import Foundation

public struct UserDTO: Codable {
    let userName: String
    let email: String
    let isHost: Bool
    let registrationDate: Date
    let profilePictureURL: URL?

    public init(
        userName: String,
        email: String,
        isHost: Bool = false,
        registrationDate: Date = Date.now,
        profilePictureURL: URL? = nil
    ) {
        self.userName = userName
        self.email = email
        self.isHost = isHost
        self.registrationDate = registrationDate
        self.profilePictureURL = profilePictureURL
    }
}
