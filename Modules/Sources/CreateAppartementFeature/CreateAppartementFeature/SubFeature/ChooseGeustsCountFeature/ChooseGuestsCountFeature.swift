//
//  ChooseGuestsCountFeature.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct ChooseGuestsCountFeature {
    @ObservableState
    public struct State {
        var guestsCount: Int = 4
        var bedroomsCount: Int = 1
        var bedsCount: Int = 1
        var bathroomsCount: Int = 1

        public init() {}
    }

    public enum Action {
        case setData(GuestsCountModel)
        case onGuestsCountChanged(Int)
        case onBedroomsCountChanged(Int)
        case onBedsCountChanged(Int)
        case onBathroomsCountChanged(Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setData(let model):
                state.guestsCount = model.guestsCount
                state.bedroomsCount = model.bedroomsCount
                state.bedsCount = model.bedsCount
                state.bathroomsCount = model.bathroomsCount

                return .none
            case .onGuestsCountChanged(let guests):
                state.guestsCount = guests
                return .none
            case .onBedroomsCountChanged(let bedrooms):
                state.bedroomsCount = bedrooms
                return .none
            case .onBedsCountChanged(let beds):
                state.bedsCount = beds
                return .none
            case .onBathroomsCountChanged(let bathrooms):
                state.bathroomsCount = bathrooms
                return .none
            }
        }
    }
}
