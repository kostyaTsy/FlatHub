//
//  ListingCellActionsBottomSheetFeature.swift
//
//
//  Created by Kostya Tsyvilko on 23.04.24.
//

import ComposableArchitecture

@Reducer
public struct ListingCellActionsBottomSheetFeature {
    @ObservableState
    public struct State {
        var appartement: HostAppartement

        public init(appartement: HostAppartement) {
            self.appartement = appartement
        }
    }

    public enum Action {
        case onEdit
        case onEditAppartement(HostAppartement)
        case onDelete
        case onDeleteAppartement(HostAppartement)
        case onChangeAvailability
        case onChangeAvailabilityAppartement(HostAppartement)
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onEdit:
                let appartement = state.appartement
                return .run { send in
                    await send(.onEditAppartement(appartement))
                    await dismiss()
                }
            case .onDelete:
                let appartement = state.appartement
                return .run { send in
                    await send(.onDeleteAppartement(appartement))
                    await dismiss()
                }
            case .onChangeAvailability:
                let appartement = state.appartement
                return .run { send in
                    await send(.onChangeAvailabilityAppartement(appartement))
                    await dismiss()
                }
            case .onEditAppartement, .onDeleteAppartement, .onChangeAvailabilityAppartement:
                return .none
            }
        }
    }
}
