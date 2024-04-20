//
//  FHContentView.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import SwiftUI

public struct FHContentView<Content: View>: View {
    public struct Configuration {
        let titleFont: Font
        let titleColor: Color
        let subtitleFont: Font
        let subtitleColor: Color

        public init(
            titleFont: Font = .system(size: 22, weight: .medium),
            titleColor: Color = .primary,
            subtitleFont: Font = .system(size: 16),
            subtitleColor: Color = .secondary
        ) {
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.subtitleFont = subtitleFont
            self.subtitleColor = subtitleColor
        }
    }

    private var title: String
    private var subtitle: String?
    private var configuration: Configuration
    @ViewBuilder private var content: () -> Content

    public init(
        title: String,
        subtitle: String? = nil,
        configuration: Configuration = Configuration(),
        content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.configuration = configuration
        self.content = content
    }


    public var body: some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.smallMedium) {
            Text(title)
                .font(configuration.titleFont)
                .foregroundStyle(configuration.titleColor)
            if let subtitle {
                Text(subtitle)
                    .font(configuration.subtitleFont)
                    .foregroundStyle(configuration.subtitleColor)
            }
            
            content()
                .padding(.top, Layout.Spacing.small)
        }
    }
}

#if DEBUG
    #Preview {
        FHContentView(title: "Title", subtitle: "Subtitle") {
            Rectangle()
                .background(.secondary)
        }
    }
#endif
