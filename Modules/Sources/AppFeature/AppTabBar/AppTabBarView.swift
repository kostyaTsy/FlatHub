//
//  AppTabBarView.swift
//
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import SwiftUI
import ComposableArchitecture

struct AppTabBarView: View {
    private let store: StoreOf<AppTabBarFeature>

    init(store: StoreOf<AppTabBarFeature>) {
        self.store = store
    }

    var body: some View {
        Text("AppContent")
            .onAppear {
                store.send(.onAppear)
            }
    }
}
