//
//  UserRole.swift
//  
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import Foundation

/// Specify current user role in app
public enum UserRole: Int, Codable {
    /// Is general user
    case `default`
    case host
}
