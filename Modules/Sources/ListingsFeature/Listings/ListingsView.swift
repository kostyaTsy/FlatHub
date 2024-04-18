//
//  ListingsView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import CreateAppartementFeature
import SwiftUI

public struct ListingsView: View {
    @Perception.Bindable private var store: StoreOf<ListingsFeature>

    public init(store: StoreOf<ListingsFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path)
            ) {
                content()
            } destination: { store in
                EmptyView()
            }
        }
    }

    @ViewBuilder private func content() -> some View {
        CreateAppartementView(
            store: .init(
                initialState: .init(), reducer: {
                    CreateAppartementFeature()
                }
            )
        )
    }
}

#if DEBUG
    #Preview {
        ListingsView(
            store: .init(
                initialState: .init(), reducer: {
                    ListingsFeature()
                }
            )
        )
    }
#endif
