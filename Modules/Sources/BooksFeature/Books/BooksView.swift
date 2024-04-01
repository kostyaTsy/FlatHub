//
//  BooksView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture
import AppartementListFeature

public struct BooksView: View {
    private let store: StoreOf<BooksFeature>

    public init(store: StoreOf<BooksFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            contentView()
        }
        .task {
            store.send(.task)
        }
    }

    @ViewBuilder private func contentView() -> some View {
        VStack {
            AppartementList(
                store: store.scope(
                    state: \.appartementList,
                    action: \.appartementList
                )
            )
        }
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
