//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 22.04.24.
//

import ComposableArchitecture

@Reducer
public struct ListingListFeature {
    @ObservableState
    public struct State {
        let appartements: [HostAppartement]
        var isDataLoaded = false

        public init(appartements: [HostAppartement]) {
            self.appartements = appartements
            if !appartements.isEmpty {
                isDataLoaded = true
            }
        }
    }

    public enum Action {
        case onEditAppartement(HostAppartement)
        case onDeleteAppartement(HostAppartement)
        case onChangeAvailability(HostAppartement)
        case onAddedNewAppartement(HostAppartement)
        case onAppartementTapped(HostAppartement)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
