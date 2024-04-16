//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture

@Reducer
public struct ListingsFeature {
    @ObservableState
    public struct State {
        var path = StackState<Path.State>()

        public init() {}
    }

    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
    }

    @Reducer
    public enum Path {
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
