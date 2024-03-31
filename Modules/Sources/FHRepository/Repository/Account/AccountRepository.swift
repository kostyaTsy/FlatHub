//
//  AccountRepository.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import Foundation
import FHAuth
import FHCommon

public protocol AccountRepositoryProtocol {
    var isUserLoggedIn: Bool { get }

    var user: User { get }

    func loadAndUpdate() async throws -> User
    func save(user: UserDTO) async throws
}

public enum AccountRepositoryError: Error {
    case noUser
}

final public class AccountRepository: AccountRepositoryProtocol {
    private enum StoreKeys {
        static let userKey = "com.tsyvilko.flathub.user"
    }

    private let userDefaults: UserDefaults
    private let authService: AuthServiceProtocol
    private let userRepository: UserRepositoryProtocol

    public init(
        userDefaults: UserDefaults = UserDefaults.standard,
        authService: AuthService = AuthService(),
        userRepository: UserRepositoryProtocol = UserRepository()
    ) {
        self.userDefaults = userDefaults
        self.authService = authService
        self.userRepository = userRepository
    }

    public var isUserLoggedIn: Bool {
        authService.currentUser != nil
    }

    public var user: User {
        guard let user: User = try? userDefaults.object(for: StoreKeys.userKey) else {
            fatalError("No saved user")
        }
        return user
    }

    public func loadAndUpdate() async throws -> User {
        guard let currentUser = authService.currentUser else {
            throw AccountRepositoryError.noUser
        }

        let user = try await userRepository.load(userId: currentUser.uid)
        try userDefaults.set(user, for: StoreKeys.userKey)
        return user
    }

    public func save(user: UserDTO) async throws {
        guard let currentUser = authService.currentUser else {
            throw AccountRepositoryError.noUser
        }

        let user = UserMapper.mapUser(with: currentUser.uid, userDTO: user)
        try await userRepository.save(user: user)
        try userDefaults.set(user, for: StoreKeys.userKey)
    }
}
