//
//  AppartementLivingType.swift
//  
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import Foundation

public struct AppartementLivingType: Identifiable, Codable {
    public let id: Int
    public let title: String
    public let description: String
    public let iconName: String

    public init(
        id: Int,
        title: String,
        description: String,
        iconName: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
    }
}
