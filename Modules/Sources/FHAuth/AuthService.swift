//
//  AuthService.swift
//
//
//  Created by Kostya Tsyvilko on 23.03.24.
//

import Foundation
import FirebaseAuth

public protocol AuthServiceProtocol {
}

final public class AuthService: AuthServiceProtocol {
    private let auth: Auth
    
    public var isUserLoggedIn: Bool {
        auth.currentUser != nil
    }
    
    public init(auth: Auth = Auth.auth()) {
        self.auth = auth
    }
}
