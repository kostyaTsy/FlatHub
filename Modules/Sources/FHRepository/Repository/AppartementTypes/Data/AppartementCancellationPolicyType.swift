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

    public init(
        id: Int,
        title: String,
        hostDescription: String,
        travelDescription: String
    ) {
        self.id = id
        self.title = title
        self.hostDescription = hostDescription
        self.travelDescription = travelDescription
    }
}
