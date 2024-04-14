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
    func save(userDTO: UserDTO) async throws
    func becomeHost(for user: User) async throws

    func updateUserRole(with mode: UserRole)
}

public enum AccountRepositoryError: Error {
    case noUser
}

final public class AccountRepository: AccountRepositoryProtocol {
    private enum StoreKeys {
        static let userKey = "com.tsyvilko.flathub.user"
        static let userModeKey = "com.tsyvilko.flathub.usermode"
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
        guard let authCurrentUser = authService.currentUser else {
            throw AccountRepositoryError.noUser
        }

        let userModel = try await userRepository.load(userId: authCurrentUser.uid)
        let localUser = loadLocalUser()
        let user = UserMapper.fromUserModel(userModel, with: localUser?.role ?? .default)
        try saveLocalUser(user)
        return user
    }

    public func save(userDTO: UserDTO) async throws {
        guard let currentUser = authService.currentUser else {
            throw AccountRepositoryError.noUser
        }

        let userModel = UserMapper.toUserModel(with: currentUser.uid, userDTO: userDTO)
        try await userRepository.save(user: userModel)
        let localUser = loadLocalUser()
        let user = UserMapper.fromUserModel(userModel, with: localUser?.role ?? .default)
        try saveLocalUser(user)
    }

    public func becomeHost(for user: User) async throws {
        if user.isHost {
            return
        }

        let userModel = UserMapper.toUserModel(user)
        try await userRepository.becomeHost(for: userModel)
        user.isHost = true
        try saveLocalUser(user)
    }

    public func updateUserRole(with mode: UserRole) {
        guard let user = loadLocalUser() else { return }
        user.role = mode
        try? saveLocalUser(user)
    }
}

private extension AccountRepository {
    func loadLocalUser() -> User? {
        try? userDefaults.object(for: StoreKeys.userKey)
    }

    func saveLocalUser(_ user: User) throws {
        try userDefaults.set(user, for: StoreKeys.userKey)
    }
}
