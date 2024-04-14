//
//  AppFeature.swift
//
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import Foundation
import ComposableArchitecture
import AuthFeature
import FHRepository

@Reducer
public struct AppFeature: Sendable {
    @Reducer
    public enum Destination {
        case authorizedUser(UserAppTabBarFeature)
        case authorizedHost(HostAppTabBarFeature)
        case unauthorized(LoginFeature)
    }
    
    @ObservableState
    public struct State {
        @Presents var destination: Destination.State?
        var isLoggedIn: Bool = false
        var shouldUpdateUser: Bool = true

        public init() {}
    }

    public enum Action {
        case onAppear
        case authorized
        case authorizedUser
        case authorizedHost
        case unauthorized
        case destination(PresentationAction<Destination.Action>)
    }

    @Dependency(\.accountRepository) var accountRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let isLoggedIn = accountRepository.isUserLoggedIn()
                if isLoggedIn {
                    return .send(.authorized)
                } else {
                    return .send(.unauthorized)
                }
            case .authorized:
                let user = accountRepository.user()
                switch user.role {
                case .default:
                    return .send(.authorizedUser)
                case .host:
                    return .send(.authorizedHost)
                }
            case .authorizedUser:
                state.isLoggedIn = true
                let userAppTabBarState = UserAppTabBarFeature.State(shouldUpdateUser: state.shouldUpdateUser)
                state.destination = .authorizedUser(userAppTabBarState)
                return .none
            case .authorizedHost:
                state.isLoggedIn = true
                let hostAppTabBarState = HostAppTabBarFeature.State()
                state.destination = .authorizedHost(hostAppTabBarState)
                return .none
            case .unauthorized:
                state.isLoggedIn = false
                state.destination = .unauthorized(LoginFeature.State())
                return .none
            case .destination(.presented(.unauthorized(.loginSuccess))):
                return .send(.authorizedUser)
            case .destination(.presented(.unauthorized(.registerSuccess))):
                state.shouldUpdateUser = false
                return .send(.authorizedUser)
            case .destination(.presented(.authorizedUser(.userLoggedOut))):
                return .send(.unauthorized)
            case .destination(.presented(.authorizedUser(.userSwitchedToHost))):
                return .send(.authorizedHost)
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
