//
//  AppTabBarFeature.swift
//  
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import ComposableArchitecture
import ExploreFeature
import FavouritesFeature
import BooksFeature
import ProfileFeature

@Reducer
public struct AppTabBarFeature {
    @ObservableState
    public struct State {
        var selection: AppTabBarFeature.Selection = .explore

        var explore = ExploreFeature.State()
        var favourites = FavouritesFeature.State()
        var books = BooksFeature.State()
        var profile = ProfileFeature.State()

        public init()  {}
    }

    public enum Action {
        case selectionChanged(AppTabBarFeature.Selection)

        case explore(ExploreFeature.Action)
        case favourites(FavouritesFeature.Action)
        case books(BooksFeature.Action)
        case profile(ProfileFeature.Action)
    }

    @Dependency(\.accountRepository) var accountRepository

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectionChanged(let selection):
                state.selection = selection
                return .none
            case .explore, .favourites, .books, .profile:
                return .none
            }
        }
    }
}

// MARK: - Selection

public extension AppTabBarFeature {
    enum Selection: Hashable {
        case explore
        case favourites
        case books
        case profile
    }
}
