//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import ListingsFeature
import BooksFeature
import EarningsFeature
import ProfileFeature

@Reducer
public struct HostAppTabBarFeature {
    @ObservableState
    public struct State {
        var shouldUpdateUser: Bool = false
        var isLoading: Bool = false
        var selection: Selection = .listings

        var listings = ListingsFeature.State()
        var books = HostBooksFeature.State()
        var earnings = EarningsFeature.State()
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
        case userSwitchedToTravel
        case selectionChanged(Selection)

        case listings(ListingsFeature.Action)
        case books(HostBooksFeature.Action)
        case earnings(EarningsFeature.Action)
        case profile(ProfileFeature.Action)
    }

    public init() {}

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
            case .profile(.switchToNewRole):
                return .send(.userSwitchedToTravel)
            case .listings, .books, .profile, .earnings:
                return .none
            case .userLoggedOut, .userSwitchedToTravel:
                return .none
            }
        }

        Scope(state: \.listings, action: \.listings) {
            ListingsFeature()
        }

        Scope(state: \.books, action: \.books) {
            HostBooksFeature()
        }

        Scope(state: \.earnings, action: \.earnings) {
            EarningsFeature()
        }

        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
    }
}

// MARK: - Selection
public extension HostAppTabBarFeature {
    enum Selection {
        case listings
        case books
        case earnings
        case profile
    }
}
