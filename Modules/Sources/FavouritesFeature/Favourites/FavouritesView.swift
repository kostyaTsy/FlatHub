//
//  FavouritesView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture
import AppartementListFeature
import FHCommon

public struct FavouritesView: View {

    private let store: StoreOf<FavouritesFeature>

    public init(store: StoreOf<FavouritesFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            contentView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .task {
            store.send(.task)
        }
    }

    @ViewBuilder private func contentView() -> some View {
        FHContentView(
            title: Strings.favouritesTabTitle,
            configuration: .init(
                horizontalPadding: Layout.Spacing.smallMedium
            )
        ) {
            VStack {
                Spacer()
                AppartementList(
                    store: store.scope(
                        state: \.appartementList,
                        action: \.appartementList
                    )
                )
                Spacer()
            }
            .frame(maxWidth: .infinity)
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
