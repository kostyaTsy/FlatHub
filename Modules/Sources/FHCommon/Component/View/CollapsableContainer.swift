//
//  SwiftUIView.swift
//  
//
//  Created by Kostya Tsyvilko on 27.04.24.
//

import SwiftUI

public struct CollapsableContainer<Content: View>: View {
    @Binding private var collapsed: Bool
    private let cornerRadius: CGFloat
    private let backgroundColor: Color
    @ViewBuilder private var headerContent: () -> Content
    @ViewBuilder private var content: () -> Content

    public init(
        collapsed: Binding<Bool>,
        cornerRadius: CGFloat = 20,
        backgroundColor: Color = .secondary,
        headerContent: @escaping () -> Content,
        content: @escaping () -> Content
    ) {
        self._collapsed = collapsed
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.headerContent = headerContent
        self.content = content
    }

    public var body: some View {
        contentView()
            .onTapGesture {
                withAnimation(.linear(duration: 0.2)) {
                    collapsed.toggle()
                }
            }
    }

    @ViewBuilder private func contentView() -> some View {
        VStack {
            headerContent()
            if !collapsed {
                content()
            }
        }
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundStyle(backgroundColor)
        }
    }
}

#if DEBUG
    #Preview {
        return CollapsableContainer(collapsed: .constant(true)) {
            Text("123")
        } content: {
            Text("123")
        }
    }
#endif
