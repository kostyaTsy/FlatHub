//
//  ListingsView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import SwiftUI
import CreateAppartementFeature
import AppartementListFeature
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
                    .onAppear {
                        UIScrollView.appearance().isScrollEnabled = true
                        store.send(.onAppear)
                    }
                    .navigationBarTitleDisplayMode(.inline)
            } destination: { store in
                switch store.case {
                case .create(let store):
                    CreateAppartementView(store: store)
                }
            }
        }
    }

    @ViewBuilder private func content() -> some View {
        VStack {
            headerView()
                .padding(.bottom, Layout.Spacing.xSmall)
            Spacer()
            ListingList(
                store: store.scope(state: \.listings, action: \.listings)
            )
            .padding(.top, Layout.Spacing.small)
            Spacer()
        }
    }

    @ViewBuilder private func headerView() -> some View {
        HStack {
            Text(Strings.listingsTabTitle)
            Spacer()

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
        .padding(.horizontal, Layout.Spacing.smallMedium)
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
