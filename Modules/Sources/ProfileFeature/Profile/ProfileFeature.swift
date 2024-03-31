//
//  ProfileFeature.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import ComposableArchitecture
import FHAuth

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State {
        public init() {}
    }

    public enum Action {
        case logOut
        case logOutSuccess
    }

    @Dependency(\.authService) var authService

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .logOut:
                do {
                    try authService.signOut()
                    return .send(.logOutSuccess)
                } catch {
                    return .none
                }
            case .logOutSuccess:
                return .none
            }
        }
    }
}
