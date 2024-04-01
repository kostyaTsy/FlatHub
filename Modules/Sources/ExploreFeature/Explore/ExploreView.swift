//
//  ExploreView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture
import AppartementListFeature

public struct ExploreView: View {
    private let store: StoreOf<ExploreFeature>

    public init(store: StoreOf<ExploreFeature>) {
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
        ExploreView(
            store: .init(
                initialState: .init(), reducer: {
                    ExploreFeature()
                }
            )
        )
    }
#endif
