//
//  FavouritesView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture
import AppartementListFeature

public struct FavouritesView: View {

    private let store: StoreOf<FavouritesFeature>

    public init(store: StoreOf<FavouritesFeature>) {
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
        FavouritesView(
            store: .init(
                initialState: .init(), reducer: {
                    FavouritesFeature()
                }
            )
        )
    }
#endif
