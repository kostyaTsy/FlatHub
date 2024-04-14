//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import ProfileFeature

@Reducer
public struct HostAppTabBarFeature {
    public struct State {
        var profile = ProfileFeature.State()
        
        public init() {}
    }

    public enum Action {
        case onAppear
        case userLoggedOut
        case userSwitchedToTravel
        case profile(ProfileFeature.Action)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .profile(.logOutSuccess):
                return .send(.userLoggedOut)
            case .profile(.switchToNewRole):
                return .send(.userSwitchedToTravel)
            case .profile:
                return .none
            case .userLoggedOut, .userSwitchedToTravel:
                return .none
            }
        }

        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
    }
}
