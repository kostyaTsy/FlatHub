//
//  AppartementTypeMapper.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import Foundation
import FHRepository

enum AppartementTypeMapper {
    static func mapToItem(
        from: AppartementType,
        isSelected: Bool = false
    ) -> AppartementItem {
        AppartementItem(
            id: from.id,
            title: from.name,
            iconName: from.iconName,
            isSelected: isSelected
        )
    }

    static func mapToItem(
        from: AppartementLivingType,
        isSelected: Bool = false
    ) -> AppartementItem {
        AppartementItem(
            id: from.id,
            title: from.title,
            description: from.description,
            iconName: from.iconName,
            isSelected: isSelected
        )
    }

    static func mapToItem(
        from: AppartementOfferType,
        isSelected: Bool = false
    ) -> AppartementItem {
        AppartementItem(
            id: from.id,
            title: from.name,
            iconName: from.iconName,
            isSelected: isSelected
        )
    }

    static func mapToType(
        from: AppartementItem
    ) -> AppartementType {
        AppartementType(
            id: from.id,
            name: from.title,
            iconName: from.iconName
        )
    }

    static func mapToLivingType(
        from: AppartementItem
    ) -> AppartementLivingType {
        AppartementLivingType(
            id: from.id,
            title: from.title,
            description: from.description ?? "",
            iconName: from.iconName
        )
    }

    static func mapToOfferType(
        from: AppartementItem
    ) -> AppartementOfferType {
        AppartementOfferType(
            id: from.id,
            name: from.title,
            iconName: from.iconName
        )
    }
}
