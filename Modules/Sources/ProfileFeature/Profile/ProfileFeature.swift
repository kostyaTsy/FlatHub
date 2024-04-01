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
        var sections: [ProfileSection] = []
        public init() {}
    }

    public enum Action {
        case onAppear
        case logOut
        case logOutSuccess
    }

    @Dependency(\.authService) var authService

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.sections = ProfileModelBuilder.build()
                return .none
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
