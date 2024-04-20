//
//  ChooseLivingTypeFeature.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct ChooseLivingTypeFeature {
    @ObservableState
    public struct State {
        var items: [AppartementItem] = []

        public init() {}
    }

    public enum Action {
        case setData([AppartementItem])
        case onSelectionChange(AppartementItem)
        case itemsChanged

        case onDataValidationChanged(Bool)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onSelectionChange(var item):
                item.isSelected.toggle()
                if let index = state.items.firstIndex(where: { $0.id == item.id }) {
                    state.items[index] = item
                }
                return .send(.itemsChanged)
            case .setData(let items):
                state.items = items
                return .send(.itemsChanged)
            case .itemsChanged:
                let selectedItems = state.items.filter { $0.isSelected }
                let isValid = selectedItems.count > 0
                return .send(.onDataValidationChanged(isValid))
            case .onDataValidationChanged:
                return .none
            }
        }
    }
}
