//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import SwiftUI
import FHCommon

enum Configuration {
    static func makeCollectionConfiguration(
        presentationType: FHItemCollection<AppartementItem>.PresentationType = .compact,
        allowMultipleSelection: Bool = true
    ) -> FHItemCollection<AppartementItem>.Configuration {
        FHItemCollection<AppartementItem>.Configuration(
            presentationType: presentationType,
            supportMultipleSelection: allowMultipleSelection,
            iconSize: 25,
            cellColor: Colors.system,
            cellSelectedColor: Colors.gray6,
            cellCornerRadius: 10,
            cellBorderColor: Colors.lightGray,
            cellSelectedBorderColor: .primary,
            cellBorderWidth: 2
        )
    }
}
