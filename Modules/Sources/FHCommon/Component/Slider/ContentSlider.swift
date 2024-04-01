//
//  ContentSlider.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import SwiftUI

public struct ContentModel<Item>: Identifiable {
    public let id: Int
    public let content: Item

    public init(id: Int, content: Item) {
        self.id = id
        self.content = content
    }
}

public enum ContentModelBuilder {
    public static func generateContentModel<T>(from data: [T]) -> [ContentModel<T>] {
        data.enumerated().map { ContentModel(id: $0.offset, content: $0.element) }
    }
}

public struct ContentSlider<Content: View, Item>: View {
    private let data: [ContentModel<Item>]
    @ViewBuilder var content: (Item) -> Content

    public init(
        data: [ContentModel<Item>],
        content: @escaping (Item) -> Content
    ) {
        self.data = data
        self.content = content
    }

    public var body: some View {
        LazyTabView {
            ForEach(data) { data in
                content(data.content)
            }
        }
        .tabViewStyle(.page)
    }
}
