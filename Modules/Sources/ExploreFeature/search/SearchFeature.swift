//
//  SearchFeature.swift
//
//
//  Created by Kostya Tsyvilko on 27.04.24.
//

import ComposableArchitecture

@Reducer
public struct SearchFeature {
    @ObservableState
    public struct State {
        public init() {}
    }

    public enum Action {
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
