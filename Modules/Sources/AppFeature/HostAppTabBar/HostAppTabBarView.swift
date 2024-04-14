//
//  HostAppTabBarView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import ProfileFeature
import SwiftUI

struct HostAppTabBarView: View {
    @Perception.Bindable private var store: StoreOf<HostAppTabBarFeature>

    init(store: StoreOf<HostAppTabBarFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            tabViewContent()
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder private func tabViewContent() -> some View {
        ProfileView(
            store: store.scope(state: \.profile, action: \.profile)
        )
    }
}

#if DEBUG
    #Preview {
        HostAppTabBarView(
            store: .init(
                initialState: .init(), reducer: {
                    HostAppTabBarFeature()
                }
            )
        )
    }
#endif
