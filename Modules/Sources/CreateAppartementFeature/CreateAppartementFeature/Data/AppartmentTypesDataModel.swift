//
//  AppartementTypesDataModel.swift
//
//
//  Created by Kostya Tsyvilko on 18.04.24.
//

import Foundation
import FHRepository

public struct AppartementTypesDataModel {
    let types: [AppartementType]
    let offers: [AppartementOfferType]
    let livings: [AppartementLivingType]
    let descriptions: [AppartementDescriptionType]
    let policies: [AppartementCancellationPolicyType]

    public init(
        types: [AppartementType] = [],
        offers: [AppartementOfferType] = [],
        livings: [AppartementLivingType] = [],
        descriptions: [AppartementDescriptionType] = [],
        policies: [AppartementCancellationPolicyType] = []
    ) {
        self.types = types
        self.offers = offers
        self.livings = livings
        self.descriptions = descriptions
        self.policies = policies
    }
}
