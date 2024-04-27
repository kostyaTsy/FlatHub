//
//  AppartementDescriptionFeature.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct AppartementDescriptionFeature {
    @ObservableState
    public struct State {
        var description: String = ""

        public init() {}
    }

    public enum Action {
        case setDescription(String)
        case onDescriptionChanged(String)

        case onDescriptionValidationChanged(Bool)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setDescription(let description):
                return .send(.onDescriptionChanged(description))
            case .onDescriptionChanged(let description):
                state.description = description
                let isValid = description.count > 0
                return .send(.onDescriptionValidationChanged(isValid))
            case .onDescriptionValidationChanged:
                return .none
            }
        }
    }
}
