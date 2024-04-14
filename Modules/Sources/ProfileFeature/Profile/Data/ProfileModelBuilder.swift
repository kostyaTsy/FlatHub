//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import Foundation
import FHRepository
import FHCommon

enum ProfileModelBuilder {
    static func build(for user: User) -> [ProfileSection] {
        var sections = [ProfileSection]()
        // MARK: - Settings
        var settingsItems = [ProfileItem]()

        let personalInfo = ProfileItem(
            title: Strings.personalInfoText,
            icon: Icons.profileIcon,
            destination: .personalInformation
        )
        settingsItems.append(personalInfo)

        let settingsSection = ProfileSection(
            name: Strings.settingsSectionText,
            items: settingsItems
        )

        sections.append(settingsSection)

        // MARK: - Hosting
        var hostingItems = [ProfileItem]()

        let switchToHosting = ProfileItem(
            title: Strings.switchToHostingText,
            icon: Icons.switchIcon,
            destination: .switchToHosting
        )
        hostingItems.append(switchToHosting)

        if user.isHost {
            let yourSpace = ProfileItem(
                title: Strings.yourSpaceText,
                icon: Icons.homeIcon,
                destination: .yourSpace
            )
            hostingItems.append(yourSpace)
        }

        let hostingSection = ProfileSection(
            name: Strings.hostingSectionText,
            items: hostingItems
        )

        return [settingsSection, hostingSection]
    }
}
