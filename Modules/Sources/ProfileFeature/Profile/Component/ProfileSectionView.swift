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

    init(section: ProfileSection) {
        self.section = section
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
        NavigationLink(value: item.destination) {
            HStack {
                item.icon
                    .padding(.trailing, Layout.Spacing.small)
                Text(item.title)
            }
        }
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
            ProfileSectionView(section: .init(name: "Test", items: []))
        }
    }
#endif
