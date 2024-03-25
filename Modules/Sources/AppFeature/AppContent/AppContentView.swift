//
//  AppContentView.swift
//
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import SwiftUI
import ComposableArchitecture

struct AppContentView: View {
    private let store: StoreOf<AppContentFeature>

    init(store: StoreOf<AppContentFeature>) {
        self.store = store
    }

    var body: some View {
        Text("AppContent")
    }
}
