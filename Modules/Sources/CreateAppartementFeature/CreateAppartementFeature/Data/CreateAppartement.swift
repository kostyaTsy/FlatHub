//
//  CreateAppartement.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import Foundation
import FHRepository

final class CreateAppartement {
    var type: AppartementType?
    var livingType: AppartementLivingType?

    // Location data

    var guestsCount: Int = 4
    var bedroomsCount: Int = 1
    var bedsCount: Int = 1
    var bathroomsCount: Int = 1

    var offers: [AppartementOfferType] = []
    var title: String?
    var description: String?
    var descriptions: [AppartementDescriptionType] = []
    var price: Int?
}
