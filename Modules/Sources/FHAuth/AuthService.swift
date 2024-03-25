//
//  AuthService.swift
//
//
//  Created by Kostya Tsyvilko on 23.03.24.
//

import Foundation
import FirebaseAuth

public protocol AuthServiceProtocol {
    var isUserLoggedIn: Bool { get }
    
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signOut() throws
}

final public class AuthService: AuthServiceProtocol {
    private let auth: Auth
    
    public var isUserLoggedIn: Bool {
        auth.currentUser != nil
    }
    
    public init(auth: Auth = Auth.auth()) {
        self.auth = auth
    }

    public func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }

    public func signUp(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }

    public func signOut() throws {
        try auth.signOut()
    }
}
