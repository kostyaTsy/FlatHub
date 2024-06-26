//
//  FHOvalButton.swift
//
//
//  Created by Kostya Tsyvilko on 26.03.24.
//

import SwiftUI

public struct FHOvalButton: View {
    public struct Configuration {
        let backgroundColor: Color
        let foregroundColor: Color
        let borderColor: Color
        let borderWidth: CGFloat
        let cornerRadius: CGFloat
        let font: Font

        public init(
            backgroundColor: Color = .blue,
            foregroundColor: Color = .white,
            borderColor: Color = .clear,
            borderWidth: CGFloat = .zero,
            cornerRadius: CGFloat = 10,
            font: Font = .system(size: 17, weight: .semibold)
        ) {
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.cornerRadius = cornerRadius
            self.font = font
        }
    }

    private let title: String
    private let disabled: Bool
    private let configuration: Configuration
    private let action: () -> Void

    public init(
        title: String,
        disabled: Bool = false,
        configuration: Configuration = Configuration(),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.disabled = disabled
        self.configuration = configuration
        self.action = action
    }

    public var body: some View {
        HStack {
            Button(action:self.action) {
                Text(self.title)
                    .frame(maxWidth:.infinity)
            }
            .buttonStyle(
                FHOvalButtonStyle(backgroundColor: configuration.backgroundColor,
                                  foregroundColor: configuration.foregroundColor,
                                  borderColor: configuration.borderColor,
                                  borderWidth: configuration.borderWidth,
                                  cornerRadius: configuration.cornerRadius,
                                  font: configuration.font,
                                  isDisabled: disabled)
            )
            .disabled(self.disabled)
        }
        .frame(maxWidth:.infinity)
    }
}

#if DEBUG
    #Preview {
        FHOvalButton(title: "Button", configuration: .init(), action: {})
    }
#endif
