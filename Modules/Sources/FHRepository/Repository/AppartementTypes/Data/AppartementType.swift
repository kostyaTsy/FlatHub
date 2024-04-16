//
//  AppartementType.swift
//
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import Foundation

public struct AppartementType: Identifiable, Codable {
    public let id: Int
    public let name: String
    public let iconName: String
}
