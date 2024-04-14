//
//  UserAppTabBarFeature.swift
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
public struct UserAppTabBarFeature {
    @ObservableState
    public struct State {
        var shouldUpdateUser: Bool = false
        var isLoading: Bool = false
        var selection: UserAppTabBarFeature.Selection = .explore

        var explore = ExploreFeature.State()
        var favourites = FavouritesFeature.State()
        var books = BooksFeature.State()
        var profile = ProfileFeature.State()

        public init(shouldUpdateUser: Bool = false) {
            self.shouldUpdateUser = shouldUpdateUser
            self.isLoading = shouldUpdateUser
        }
    }

    public enum Action {
        case onAppear
        case userUpdated
        case userLoggedOut
        case selectionChanged(UserAppTabBarFeature.Selection)

        case explore(ExploreFeature.Action)
        case favourites(FavouritesFeature.Action)
        case books(BooksFeature.Action)
        case profile(ProfileFeature.Action)
    }

    @Dependency(\.accountRepository) var accountRepository

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.shouldUpdateUser else {
                    return .none
                }

                return .run { send in
                    _ = try? await accountRepository.loadAndUpdate()
                    await send(.userUpdated)
                }
            case .userUpdated:
                state.shouldUpdateUser = false
                state.isLoading = false
                return .none
            case .selectionChanged(let selection):
                state.selection = selection
                return .none
            case .profile(.logOutSuccess):
                return .send(.userLoggedOut)
            case .explore, .favourites, .books, .profile:
                return .none
            case .userLoggedOut:
                return .none
            }
        }

        Scope(state: \.explore, action: \.explore) {
            ExploreFeature()
        }

        Scope(state: \.favourites, action: \.favourites) {
            FavouritesFeature()
        }

        Scope(state: \.books, action: \.books) {
            BooksFeature()
        }

        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
    }
}

// MARK: - Selection

public extension UserAppTabBarFeature {
    enum Selection: Hashable {
        case explore
        case favourites
        case books
        case profile
    }
}
