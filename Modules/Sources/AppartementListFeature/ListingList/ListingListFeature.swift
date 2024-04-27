//
//  ListingListFeature.swift
//  
//
//  Created by Kostya Tsyvilko on 22.04.24.
//

import ComposableArchitecture

@Reducer
public struct ListingListFeature {
    @ObservableState
    public struct State {
        var appartements: [HostAppartement]
        var isDataLoaded = false

        @Presents var bottomSheet: ListingCellActionsBottomSheetFeature.State?

        public init(appartements: [HostAppartement]) {
            self.appartements = appartements
            if !appartements.isEmpty {
                isDataLoaded = true
            }
        }
    }

    public enum Action {
        case onEdit(HostAppartement)
        case onDeleteDone(HostAppartement)
        case onChangeDone(HostAppartement)
        case onAddedNewAppartement(HostAppartement)
        case setAppartements([HostAppartement])
        case onAppartementTapped(HostAppartement)

        case bottomSheet(PresentationAction<ListingCellActionsBottomSheetFeature.Action>)
    }

    @Dependency(\.appartementRepository) var appartementRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .bottomSheet(.presented(.onEditAppartement(let appartement))):
                return .send(.onEdit(appartement))
            case .onEdit:
                return .none
            case .bottomSheet(.presented(.onDeleteAppartement(let appartement))):
                return .run { send in
                    do {
                        try await appartementRepository.deleteAppartement(appartement.id)
                        await send(.onDeleteDone(appartement), animation: .linear(duration: 0.3))
                    } catch {
                        // TODO: handle error
                    }
                }
            case .onDeleteDone(let appartement):
                state.appartements.removeAll(where: { $0.id == appartement.id })
                return .none
            case .bottomSheet(.presented(.onChangeAvailabilityAppartement(let appartement))):
                return .run { send in
                    let dto = HostAppartementMapper.mapToAppartementAvailabilityDTO(from: appartement)
                    do {
                        try await appartementRepository.updateAppartementAvailability(dto)
                        await send(.onChangeDone(appartement))
                    } catch {
                        // TODO: handle error
                    }
                }
            case .onChangeDone(var appartement):
                appartement.isAvailableForBook.toggle()
                if let index = state.appartements.firstIndex(where: { $0.id == appartement.id }) {
                    state.appartements[index] = appartement
                }
                return .none
            case .onAddedNewAppartement(let appartement):
                state.appartements.append(appartement)
                state.appartements.sort { $0.createDate > $1.createDate }
                return .none
            case .setAppartements(let appartements):
                state.appartements = appartements
                state.appartements.sort { $0.createDate > $1.createDate }
                state.isDataLoaded = true
                return .none
            case .onAppartementTapped(let appartement):
                state.bottomSheet = .init(appartement: appartement)
                return .none
            case .bottomSheet:
                return .none
            }
        }
        .ifLet(\.$bottomSheet, action: \.bottomSheet) {
            ListingCellActionsBottomSheetFeature()
        }
    }
}
