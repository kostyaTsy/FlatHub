//
//  AppartementAvailabilityDTO.swift
//
//
//  Created by Kostya Tsyvilko on 23.04.24.
//

import Foundation

public struct AppartementAvailabilityDTO {
    let id: String
    let isAvailable: Bool

    public init(
        id: String,
        isAvailable: Bool
    ) {
        self.id = id
        self.isAvailable = isAvailable
    }
}
