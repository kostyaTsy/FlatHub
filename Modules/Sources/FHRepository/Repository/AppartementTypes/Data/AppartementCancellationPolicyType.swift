//
//  AppartementCancellationPolicyType.swift
//
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import Foundation

public struct AppartementCancellationPolicyType: Identifiable, Codable {
    public let id: Int
    public let title: String
    public let hostDescription: String
    public let travelDescription: String
}
