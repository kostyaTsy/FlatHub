//
//  AddPriceFeature.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct AddPriceFeature {
    @ObservableState
    public struct State {
        var price: String = "\(Constants.defaultPrice)"

        public init() {}
    }

    public enum Action {
        case setPrice(Int?)
        case onPriceChanged(String)

        case onPriceValidationChanged(Bool)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setPrice(let price):
                let priceString = "\(price ?? Constants.defaultPrice)"
                return .send(.onPriceChanged(priceString))
            case .onPriceChanged(let price):
                state.price = price
                let isValid = price.count > 0 && (Int(price) != nil)
                return .send(.onPriceValidationChanged(isValid))
            case .onPriceValidationChanged:
                return .none
            }
        }
    }
}

private extension AddPriceFeature {
    enum Constants {
        static let defaultPrice = 20
    }
}
