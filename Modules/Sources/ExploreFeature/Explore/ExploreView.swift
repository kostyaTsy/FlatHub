//
//  ExploreView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture
import AppartementListFeature
import FHCommon

public struct ExploreView: View {
    @Perception.Bindable private var store: StoreOf<ExploreFeature>

    public init(store: StoreOf<ExploreFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            contentView()
                .toolbar(.hidden, for: .navigationBar)
                .fullScreenCover(
                    item: $store.scope(state: \.search, action: \.search)
                ) { store in
                    SearchView(store: store)
                }
        }
        .task {
            store.send(.task)
        }
    }

    @ViewBuilder private func contentView() -> some View {
        VStack {
            SearchContainer()
                .padding(.bottom, Layout.Spacing.small)
                .padding(.horizontal, Layout.Spacing.smallMedium)
                .onTapGesture {
                    store.send(.onSearchContainerTaped)
                }
            
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
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            ExploreView(
                store: .init(
                    initialState: .init(), reducer: {
                        ExploreFeature()
                    }
                )
            )
        }
    }
#endif
