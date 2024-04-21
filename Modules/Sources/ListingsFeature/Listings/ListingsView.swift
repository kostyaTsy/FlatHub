//
//  ListingsView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import SwiftUI
import CreateAppartementFeature
import FHCommon

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
                    .toolbar(.visible, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                store.send(.addButtonTapped)
                            } label: {
                                Icons.plusIcon
                                    .padding(.all, Layout.Spacing.xSmall)
                                    .foregroundStyle(Colors.system)
                                    .background(Colors.secondary)
                                    .clipShape(Circle())
                            }
                        }
                    }
            } destination: { store in
                switch store.case {
                case .create(let store):
                    CreateAppartementView(store: store)
                }
            }
        }
    }

    @ViewBuilder private func content() -> some View {
        Text("Listings")
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
