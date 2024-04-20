//
//  AppartementItem.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import Foundation
import FHCommon

public struct AppartementItem: FHCollectionItem {
    public var id: Int
    public let title: String
    public let description: String?
    public let iconName: String
    public var isSelected: Bool

    public init(
        id: Int,
        title: String,
        description: String? = nil,
        iconName: String,
        isSelected: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.isSelected = isSelected
    }
}
