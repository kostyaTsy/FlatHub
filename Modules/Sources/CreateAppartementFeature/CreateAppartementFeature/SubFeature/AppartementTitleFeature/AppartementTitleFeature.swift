//
//  AppartementTitleFeature.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct AppartementTitleFeature {
    @ObservableState
    public struct State {
        var title: String = ""

        public init() {}
    }

    public enum Action {
        case setTitle(String)
        case onTitleChanged(String)

        case onTitleValidationChanged(Bool)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setTitle(let title):
                return .send(.onTitleChanged(title))
            case .onTitleChanged(let title):
                state.title = title
                let isValid = title.count > 0
                return .send(.onTitleValidationChanged(isValid))
            case .onTitleValidationChanged:
                return .none
            }
        }
    }
}
