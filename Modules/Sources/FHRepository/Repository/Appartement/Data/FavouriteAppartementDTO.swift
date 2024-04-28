//
//  FavouriteAppartementDTO.swift
//  
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation

public struct FavouriteAppartementDTO: Codable {
    public let userId: String
    public let appartement: AppartementDTO

    public init(
        userId: String,
        appartement: AppartementDTO
    ) {
        self.userId = userId
        self.appartement = appartement
    }
}
