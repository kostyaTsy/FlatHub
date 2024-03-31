//
//  AuthServiceDependency.swift
//
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import Dependencies

public struct AuthServiceDependency: Sendable {
    public var signIn: @Sendable (_ email: String, _ password: String) async throws -> Void
    public var signUp: @Sendable (_ email: String, _ password: String) async throws -> Void
    public var signOut: @Sendable () throws -> Void
}

// MARK: - Live

extension AuthServiceDependency {
    static func live(authService: AuthServiceProtocol = AuthService()) -> AuthServiceDependency {
        let dependencyService = AuthServiceDependency(
            signIn: { email, password in
                try await authService.signIn(email: email, password: password)
            },
            signUp: { email, password in
                try await authService.signUp(email: email, password: password)
            },
            signOut: {
                try authService.signOut()
            }
        )

        return dependencyService
    }
}

// MARK: - Dependency

extension AuthServiceDependency: DependencyKey {
    public static var liveValue: AuthServiceDependency {
        AuthServiceDependency.live()
    }
}

extension DependencyValues {
    public var authService: AuthServiceDependency {
        get { self[AuthServiceDependency.self] }
        set { self[AuthServiceDependency.self] = newValue }
    }
}
