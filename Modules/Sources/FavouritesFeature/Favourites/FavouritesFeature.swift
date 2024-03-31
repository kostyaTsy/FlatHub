//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import ComposableArchitecture

@Reducer
public struct FavouritesFeature {
    @ObservableState
    public struct State {
        public init() {}
    }

    public enum Action {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
