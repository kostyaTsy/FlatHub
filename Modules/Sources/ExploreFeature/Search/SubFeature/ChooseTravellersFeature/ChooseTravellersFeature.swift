//
//  ChooseTravellersFeature.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import ComposableArchitecture

@Reducer
public struct ChooseTravellersFeature {
    @ObservableState
    public struct State {
        var isCollapsed: Bool = true
        var guestsCount: Int = 2

        public init() {}
    }

    public enum Action {
        case onChangeCollapse(Bool)
        case onChangeGuestsCount(Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onChangeCollapse(let isCollapsed):
                state.isCollapsed = isCollapsed
                return .none
            case .onChangeGuestsCount(let count):
                state.guestsCount = count
                return .none
            }
        }
    }
}
