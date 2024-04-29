//
//  SearchContainer.swift
//
//
//  Created by Kostya Tsyvilko on 27.04.24.
//

import SwiftUI
import FHCommon

struct SearchContainer: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.containerHeight / 2)
                .frame(height: Constants.containerHeight)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)

            content()
                .padding(.leading)

        }
    }

    @ViewBuilder private func content() -> some View {
        HStack(spacing: Layout.Spacing.small) {
            Icons.searchIcon
            Text(Strings.searchContainerText)

            Spacer()
        }
        .foregroundStyle(.white.opacity(0.9))
        .fontWeight(.medium)
    }
}

private extension SearchContainer {
    enum Constants {
        static let containerHeight: CGFloat = 50
        static let containerShadowRadius: CGFloat = 3
    }
}

#Preview {
    SearchContainer()
}
