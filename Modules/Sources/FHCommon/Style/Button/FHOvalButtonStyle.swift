//
//  FHOvalButtonStyle.swift
//
//
//  Created by Kostya Tsyvilko on 26.03.24.
//

import SwiftUI

public struct FHOvalButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let font: Font
    let isDisabled: Bool

    public init(
        backgroundColor: Color,
        foregroundColor: Color,
        borderColor: Color = .clear,
        borderWidth: CGFloat = .zero,
        cornerRadius: CGFloat = 10,
        font: Font = .system(size: 17, weight: .semibold),
        isDisabled: Bool = false
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.font = font
        self.isDisabled = isDisabled
    }

    public func makeBody(configuration: Configuration) -> some View {
        let currentForegroundColor = isDisabled || configuration.isPressed ? foregroundColor.opacity(Constants.disabledOpacity) : foregroundColor
        return configuration.label
            .padding()
            .foregroundColor(currentForegroundColor)
            .background(isDisabled || configuration.isPressed ? backgroundColor.opacity(Constants.disabledOpacity) : backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .padding([.top, .bottom])
            .font(font)
    }
}

extension FHOvalButtonStyle {
    private enum Constants {
        static let disabledOpacity: CGFloat = 0.3
    }
}

#if DEBUG
    #Preview {
        Button {  } label: {
            Text("Test")
        }
        .buttonStyle(FHOvalButtonStyle(backgroundColor: .blue, foregroundColor: .white, isDisabled: true))
    }
#endif
