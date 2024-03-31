//
//  AppTabBarFeature.swift
//  
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import ComposableArchitecture

@Reducer
public struct AppTabBarFeature {
    public struct State {
    }

    public enum Action {
        case none
        case onAppear
    }

    @Dependency(\.accountRepository) var accountRepository

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .none:
                return .none
            case .onAppear:
                let user = accountRepository.user()
                print(">>> \(user)")
                return .none
            }
        }
    }
}
