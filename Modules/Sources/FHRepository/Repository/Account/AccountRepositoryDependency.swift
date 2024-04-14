//
//  AccountRepositoryDependency.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import Dependencies

public struct AccountRepositoryDependency: Sendable {
    public var isUserLoggedIn: @Sendable () -> Bool
    public var user: @Sendable () -> User

    public var loadAndUpdate: @Sendable () async throws -> User
    public var save: @Sendable (_ user: UserDTO) async throws -> Void
}

// MARK: - Live

extension AccountRepositoryDependency {
    static func live(accountRepository: AccountRepositoryProtocol = AccountRepository()) -> AccountRepositoryDependency {
        let dependencyRepository = AccountRepositoryDependency(
            isUserLoggedIn: {
                accountRepository.isUserLoggedIn
            },
            user: {
                accountRepository.user
            },
            loadAndUpdate: {
                try await accountRepository.loadAndUpdate()
            },
            save: { user in
                try await accountRepository.save(user: user)
            }
        )

        return dependencyRepository
    }
}

// MARK: - mock

extension AccountRepositoryDependency {
    static func mock() -> AccountRepositoryDependency {
        let mockUser = User(id: "test", userName: "Test", email: "test@example.com")
        let mockDependencyRepository = AccountRepositoryDependency(
            isUserLoggedIn: {
                true
            },
            user: {
                mockUser
            },
            loadAndUpdate: {
                mockUser
            },
            save: { user in
                ()
            }
        )

        return mockDependencyRepository
    }
}

// MARK: - Dependency

extension AccountRepositoryDependency: DependencyKey {
    public static var liveValue: AccountRepositoryDependency {
        AccountRepositoryDependency.live()
    }

    public static var previewValue: AccountRepositoryDependency {
        AccountRepositoryDependency.mock()
    }

    public static var testValue: AccountRepositoryDependency {
        AccountRepositoryDependency.mock()
    }
}

extension DependencyValues {
    public var accountRepository: AccountRepositoryDependency {
        get { self[AccountRepositoryDependency.self] }
        set { self[AccountRepositoryDependency.self] = newValue }
    }
}
