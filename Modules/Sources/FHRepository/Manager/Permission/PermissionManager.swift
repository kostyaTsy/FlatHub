//
//  PermissionManager.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import Foundation
import CoreLocation

protocol PermissionManagerProtocol {
    func request(for type: PermissionType) async -> PermissionResult
}

/// The types of permissions that can be requested.
public enum PermissionType {
    case location
}

/// The possible results of a permission request.
public enum PermissionResult {
    case granted
    case limited
    case denied
    case error(_ error: Error)
}

public actor PermissionManager: PermissionManagerProtocol {

    public init() {}

    func request(for type: PermissionType) async -> PermissionResult {
        return .denied
    }
}
