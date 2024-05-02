//
//  FavouriteAppartementRequestDTO.swift
//
//
//  Created by Kostya Tsyvilko on 29.04.24.
//

import Foundation

public struct FavouriteAppartementRequestDTO {
    public let userId: String
    public let appartementId: String

    public var documentId: String {
        "\(userId)_\(appartementId)"
    }

    public init(
        userId: String,
        appartementId: String
    ) {
        self.userId = userId
        self.appartementId = appartementId
    }
}
