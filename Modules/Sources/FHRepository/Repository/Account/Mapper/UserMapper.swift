//
//  UserMapper.swift
//  
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import Foundation

enum UserMapper {
    static func mapUser(
        with userId: String,
        userDTO: UserDTO
    ) -> User {
        User(
            id: userId,
            userName: userDTO.userName,
            email: userDTO.email,
            isHost: userDTO.isHost,
            registrationDate: userDTO.registrationDate,
            profilePictureURL: userDTO.profilePictureURL
        )
    }
}
