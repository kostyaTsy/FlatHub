//
//  FavouritesView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture

public struct FavouritesView: View {

    private let store: StoreOf<FavouritesFeature>

    public init(store: StoreOf<FavouritesFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Favourites")
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
