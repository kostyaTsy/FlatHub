//
//  ProfileModel.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import SwiftUI

enum ProfileNavigationDestination {
    case personalInformation
    case switchToHosting
    case switchToTravel
    case yourSpace
}

struct ProfileSection: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let items: [ProfileItem]
}

struct ProfileItem: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let icon: Image
    let destination: ProfileNavigationDestination
}
