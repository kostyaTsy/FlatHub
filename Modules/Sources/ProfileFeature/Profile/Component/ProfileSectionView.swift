//
//  ProfileSectionView.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import SwiftUI
import FHCommon

struct ProfileSectionView: View {
    private let section: ProfileSection
    private let onSwitchToTapped: (() -> Void)?

    init(
        section: ProfileSection,
        onSwitchToHostingTapped: (() -> Void)? = nil
    ) {
        self.section = section
        self.onSwitchToTapped = onSwitchToHostingTapped
    }

    var body: some View {
        Section {
            ForEach(section.items) { item in
                profileSectionRow(item: item)
            }
        } header: {
            Text(section.name)
                .font(.system(size: Constants.sectionNameFontSize))
                .fontWeight(.medium)
                .textCase(.none)
        }
    }

    @ViewBuilder private func profileSectionRow(item: ProfileItem) -> some View {
        if item.destination == .switchToHosting || item.destination == .switchToTravel {
            Button {
                onSwitchToTapped?()
            } label: {
                profileSectionRowContent(item: item)
                    .foregroundStyle(Colors.label)
            }
        } else {
            NavigationLink(value: item.destination) {
                profileSectionRowContent(item: item)
            }
        }
    }

    @ViewBuilder private func profileSectionRowContent(item: ProfileItem) -> some View {
        HStack {
            item.icon
                .padding(.trailing, Layout.Spacing.small)
            Text(item.title)
        }
        .tag(item.destination)
    }
}

private extension ProfileSectionView {
    enum Constants {
        static let sectionNameFontSize: CGFloat = 20
    }
}

#if DEBUG
    #Preview {
        List {
            let profileItem = ProfileItem(title: "Test", icon: Icons.switchIcon, destination: .switchToHosting)
            ProfileSectionView(section: .init(name: "Test", items: [profileItem]))
        }
    }
#endif
