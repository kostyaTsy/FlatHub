//
//  EnablePagedScrolling.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import SwiftUI

/// This modifier provides backwards compatibility for paged scrolling
/// and is meant to be attached to any ScrollView.
struct EnablePagedScrolling: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .scrollTargetBehavior(.viewAligned)
        } else {
            content
                .onAppear {
                    UIScrollView.appearance().isPagingEnabled = true
                }
        }
    }
}

public extension View {
    func enablePagedScrolling() -> some View {
        modifier(EnablePagedScrolling())
    }
}
