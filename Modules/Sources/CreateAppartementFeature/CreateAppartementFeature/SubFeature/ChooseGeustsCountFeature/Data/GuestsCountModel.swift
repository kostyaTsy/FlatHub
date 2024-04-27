//
//  GuestsCountModel.swift
//  
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import Foundation

public struct GuestsCountModel {
    let guestsCount: Int
    let bedroomsCount: Int
    let bedsCount: Int
    let bathroomsCount: Int

    public init(
        guestsCount: Int,
        bedroomsCount: Int,
        bedsCount: Int,
        bathroomsCount: Int
    ) {
        self.guestsCount = guestsCount
        self.bedroomsCount = bedroomsCount
        self.bedsCount = bedsCount
        self.bathroomsCount = bathroomsCount
    }
}
