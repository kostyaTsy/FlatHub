//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import CreateAppartementFeature

@Reducer
public struct ListingsFeature {
    @ObservableState
    public struct State {
        var path = StackState<Path.State>()

        public init() {}
    }

    public enum Action {
        case addButtonTapped
        case path(StackAction<Path.State, Path.Action>)
    }

    @Reducer
    public enum Path {
        case create(CreateAppartementFeature)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.path.append(.create(.init()))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
