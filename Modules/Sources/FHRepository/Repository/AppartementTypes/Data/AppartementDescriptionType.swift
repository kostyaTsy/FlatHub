//
//  AppartementDescriptionType.swift
//  
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import Foundation

public struct AppartementDescriptionType: Identifiable, Codable {
    public let id: Int
    public let name: String
    public let iconName: String

    public init(
        id: Int,
        name: String,
        iconName: String
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
    }
}
