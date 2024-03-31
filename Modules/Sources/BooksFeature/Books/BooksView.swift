//
//  BooksView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture

public struct BooksView: View {
    private let store: StoreOf<BooksFeature>

    public init(store: StoreOf<BooksFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Books")
    }
}

#if DEBUG
    #Preview {
        BooksView(
            store: .init(
                initialState: .init(), reducer: {
                    BooksFeature()
                }
            )
        )
    }
#endif
