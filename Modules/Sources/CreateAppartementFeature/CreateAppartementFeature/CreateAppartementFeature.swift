//
//  CreateAppartementFeature.swift
//
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import ComposableArchitecture

@Reducer
public struct CreateAppartementFeature {
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
