//
//  AppView.swift
//
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import SwiftUI
import AuthFeature
import ComposableArchitecture

public struct AppView: View {
    @Perception.Bindable public var store: StoreOf<AppFeature>

    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                if store.isLoggedIn, let newStore = $store.scope(
                    state: \.destination?.loggedIn,
                    action: \.destination.loggedIn
                ).wrappedValue {
                    AppTabBarView(store: newStore)
                } else if !store.isLoggedIn, let newStore = $store.scope(
                    state: \.destination?.loggedOut,
                    action: \.destination.loggedOut
                ).wrappedValue {
                    LoginView(store: newStore)
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}
