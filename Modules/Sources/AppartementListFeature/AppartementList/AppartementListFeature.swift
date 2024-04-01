//
//  AppartementListFeature.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct AppartementListFeature {
    @ObservableState
    public struct State {
        var appartements: [Appartement]
        var isDataLoaded = false


        public init(appartements: [Appartement]) {
            self.appartements = appartements
            if !appartements.isEmpty {
                isDataLoaded = true
            }
        }
    }

    public enum Action {
        case onFavouriteButtonTapped(Appartement)
        case onAppartementTapped(Appartement)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onFavouriteButtonTapped(var appartement):
                appartement.isFavourite.toggle()
                if let index = state.appartements.firstIndex(where: { $0.id == appartement.id }) {
                    state.appartements[index] = appartement
                }
                return .none
            case .onAppartementTapped(let appartement):
                return .none
            }
        }
    }
}
