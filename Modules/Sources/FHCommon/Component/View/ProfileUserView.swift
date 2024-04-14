//
//  ProfileUserView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import SwiftUI

public struct ProfileUserView: View {
    public struct Configuration {
        let name: String
        let initialsColor: Color
        let defaultProfileIconColor: Color
        let photoPath: URL?

        var initials: String {
            String(name.first ?? Character(""))
        }

        public init(
            name: String,
            initialsColor: Color = .white,
            defaultProfileIconColor: Color = Colors.lightGray,
            photoPath: URL? = nil
        ) {
            self.name = name
            self.initialsColor = initialsColor
            self.defaultProfileIconColor = defaultProfileIconColor
            self.photoPath = photoPath
        }
    }

    private let configuration: Configuration

    public init(
        configuration: Configuration
    ) {
        self.configuration = configuration
    }

    public var body: some View {
        HStack {
            userIcon()
                .padding(.trailing, Layout.Spacing.small)
            Text(configuration.name)
        }
    }

    @ViewBuilder private func userIcon() -> some View {
        ZStack {
            Circle()
                .foregroundStyle(configuration.defaultProfileIconColor)
                .frame(width: Constants.profileIconSize, height: Constants.profileIconSize)
            Text(configuration.initials)
                .font(.title2)
                .foregroundStyle(.white)
        }
    }
}

private extension ProfileUserView {
    enum Constants {
        static let profileIconSize: CGFloat = 50
    }
}

#if DEBUG
    #Preview {
        let config = ProfileUserView.Configuration(name: "Test")
        return ProfileUserView(configuration: config)
    }
#endif
