//
//  UserMapper.swift
//  
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import Foundation

enum UserMapper {
    static func toUserModel(
        with userId: String,
        userDTO: UserDTO
    ) -> UserModel {
        UserModel(
            id: userId,
            userName: userDTO.userName,
            email: userDTO.email,
            isHost: userDTO.isHost,
            registrationDate: userDTO.registrationDate,
            profilePictureURL: userDTO.profilePictureURL
        )
    }

    static func toUserModel(
        _ user: User
    ) -> UserModel {
        UserModel(
            id: user.id,
            userName: user.userName,
            email: user.email,
            isHost: user.isHost,
            registrationDate: user.registrationDate,
            profilePictureURL: user.profilePictureURL
        )
    }

    static func fromUserModel(
        _ userModel: UserModel,
        with role: UserRole
    ) -> User {
        User(
            id: userModel.id,
            userName: userModel.userName,
            email: userModel.email,
            isHost: userModel.isHost,
            role: role,
            registrationDate: userModel.registrationDate,
            profilePictureURL: userModel.profilePictureURL
        )
    }
}
