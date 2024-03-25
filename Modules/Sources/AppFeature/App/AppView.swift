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
//                if store.isLoggedIn {
//                    AppContentView(store: .init(initialState: .init(), reducer: {
//                        AppContentFeature()
//                    }))
//                } else {
//                    LoginView(store: .init(initialState: .init(), reducer: {
//                        LoginFeature()
//                    }))
//                }
                if store.isLoggedIn, let newStore = $store.scope(
                    state: \.destination?.loggedIn,
                    action: \.destination.loggedIn
                ).wrappedValue {
                    AppContentView(store: newStore)
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

//    public var body: some View {
//        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
//            Text("Root")
//        } destination: { store in
//            switch store.state {
//            case .loggedIn:
//                if let store = store.scope(state: \.loggedIn, action: \.loggedIn) {
//                    AppContentView(store: store)
//                }
//            case .loggedOut:
//                if let store = store.scope(state: \.loggedOut, action: \.loggedOut) {
//                    LoginView(store: store)
//                }
//            }
//        }
//
//    }
