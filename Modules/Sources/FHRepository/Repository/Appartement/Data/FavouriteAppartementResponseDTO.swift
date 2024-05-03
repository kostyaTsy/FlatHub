//
//  FavouriteAppartementResponseDTO.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation

public struct FavouriteAppartementResponseDTO: Codable {
    public let userId: String
    public let appartementId: String

    public init(
        userId: String,
        appartementId: String
    ) {
        self.userId = userId
        self.appartementId = appartementId
    }
}
