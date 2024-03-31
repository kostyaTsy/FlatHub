//
//  AppTabBarView.swift
//
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import SwiftUI
import ComposableArchitecture
import ExploreFeature
import FavouritesFeature
import BooksFeature
import ProfileFeature
import FHCommon

struct AppTabBarView: View {
    @Perception.Bindable private var store: StoreOf<AppTabBarFeature>

    init(store: StoreOf<AppTabBarFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.selection.sending(\.selectionChanged)) {
                ExploreFeatureTab(
                    store: store.scope(state: \.explore, action: \.explore)
                )
                .tag(AppTabBarFeature.Selection.explore)

                FavouritesFeatureTab(
                    store: store.scope(state: \.favourites, action: \.favourites)
                )
                .tag(AppTabBarFeature.Selection.favourites)

                BooksFeatureTab(
                    store: store.scope(state: \.books, action: \.books)
                )
                .tag(AppTabBarFeature.Selection.books)

                ProfileFeatureTab(
                    store: store.scope(state: \.profile, action: \.profile)
                )
                .tag(AppTabBarFeature.Selection.profile)
            }
        }
    }
}

// MARK: - Tabs

private struct ExploreFeatureTab: View {
    private let store: StoreOf<ExploreFeature>

    init(store: StoreOf<ExploreFeature>) {
        self.store = store
    }

    var body: some View {
        ExploreView(store: store)
            .tabItem {
                HStack {
                    Text(Strings.exploreTabTitle)
                    Icons.searchIcon
                }
            }
    }
}

private struct FavouritesFeatureTab: View {
    private let store: StoreOf<FavouritesFeature>

    init(store: StoreOf<FavouritesFeature>) {
        self.store = store
    }

    var body: some View {
        FavouritesView(store: store)
            .tabItem {
                HStack {
                    Text(Strings.favouritesTabTitle)
                    Icons.favouriteIcon
                }
            }
    }
}

private struct BooksFeatureTab: View {
    private let store: StoreOf<BooksFeature>

    init(store: StoreOf<BooksFeature>) {
        self.store = store
    }

    var body: some View {
        BooksView(store: store)
            .tabItem {
                HStack {
                    Text(Strings.booksTabTitle)
                    Icons.suiteCaseIcon
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
