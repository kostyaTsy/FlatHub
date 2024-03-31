//
//  ExploreView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture

public struct ExploreView: View {
    private let store: StoreOf<ExploreFeature>

    public init(store: StoreOf<ExploreFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Explore")
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
