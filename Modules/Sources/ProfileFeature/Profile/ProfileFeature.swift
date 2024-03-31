//
//  ProfileFeature.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import ComposableArchitecture

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State {
        public init() {}
    }

    public struct Action {

    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
