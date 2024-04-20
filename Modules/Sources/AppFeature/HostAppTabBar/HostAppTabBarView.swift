//
//  HostAppTabBarView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import SwiftUI
import ListingsFeature
import BooksFeature
import EarningsFeature
import ProfileFeature
import FHCommon

struct HostAppTabBarView: View {
    @Perception.Bindable private var store: StoreOf<HostAppTabBarFeature>

    init(store: StoreOf<HostAppTabBarFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            if store.isLoading {
                ProgressView(Strings.loadingText)
            } else {
                tabViewContent()
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder private func tabViewContent() -> some View {
        TabView(selection: $store.selection.sending(\.selectionChanged)) {
            ListingsFeatureTab(
                store: store.scope(state: \.listings, action: \.listings)
            )
            .tag(HostAppTabBarFeature.Selection.listings)

            BooksFeatureTab(
                store: store.scope(state: \.books, action: \.books)
            )
            .tag(HostAppTabBarFeature.Selection.books)

            EarningsFeatureTab(
                store: store.scope(state: \.earnings, action: \.earnings)
            )
            .tag(HostAppTabBarFeature.Selection.earnings)

            ProfileFeatureTab(
                store: store.scope(state: \.profile, action: \.profile)
            )
            .tag(HostAppTabBarFeature.Selection.profile)
        }
    }
}

// MARK: - Tabs

private struct ListingsFeatureTab: View {
    private let store: StoreOf<ListingsFeature>

    public init(store: StoreOf<ListingsFeature>) {
        self.store = store
    }

    var body: some View {
        ListingsView(store: store)
            .tabItem {
                HStack {
                    Text(Strings.listingsTabTitle)
                    Icons.listBulletIcon
                }
            }
    }
}

private struct BooksFeatureTab: View {
    private let store: StoreOf<HostBooksFeature>

    init(store: StoreOf<HostBooksFeature>) {
        self.store = store
    }

    var body: some View {
        HostBooksView(store: store)
            .tabItem {
                HStack {
                    Text(Strings.booksTabTitle)
                    Icons.suiteCaseIcon
                }
            }
    }
}

private struct EarningsFeatureTab: View {
    private let store: StoreOf<EarningsFeature>

    init(store: StoreOf<EarningsFeature>) {
        self.store = store
    }

    var body: some View {
        EarningsView(store: store)
            .tabItem {
                HStack {
                    Text(Strings.earningsTabTitle)
                    Icons.dollarSignIcon
                }
            }
    }
}

private struct ProfileFeatureTab: View {
    private let store: StoreOf<ProfileFeature>

    init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }

    var body: some View {
        ProfileView(store: store)
            .tabItem {
                HStack {
                    Text(Strings.profileTabTitle)
                    Icons.profileIcon
                }
            }
    }
}
