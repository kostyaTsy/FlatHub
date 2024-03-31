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
        case loggedIn(AppTabBarFeature)
        case loggedOut(LoginFeature)
    }
    
    @ObservableState
    public struct State {
        @Presents var destination: Destination.State?
        var isLoggedIn: Bool = false

        public init() {}
    }

    public enum Action {
        case onAppear
        case loggedIn
        case loggedOut
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
                    return .send(.loggedIn)
                } else {
                    return .send(.loggedOut)
                }
            case .loggedIn:
                state.isLoggedIn = true
                state.destination = .loggedIn(AppTabBarFeature.State())
                return .none
            case .loggedOut:
                state.isLoggedIn = false
                state.destination = .loggedOut(LoginFeature.State())
                return .none
            case .destination(.presented(.loggedOut(.loginSuccess))):
                return .send(.loggedIn)
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
