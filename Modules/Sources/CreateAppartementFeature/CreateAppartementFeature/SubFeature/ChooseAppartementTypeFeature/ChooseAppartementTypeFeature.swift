//
//  ChooseAppartementTypeFeature.swift
//
//
//  Created by Kostya Tsyvilko on 17.04.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct ChooseAppartementTypeFeature {
    @ObservableState
    public struct State {
        public var types: [AppartementType] = []
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
