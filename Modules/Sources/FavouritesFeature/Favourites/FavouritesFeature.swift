//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import ComposableArchitecture
import AppartementListFeature
import FHRepository

@Reducer
public struct FavouritesFeature {
    @ObservableState
    public struct State {
        var appartementList = AppartementListFeature.State(appartements: [])
        public init() {}
    }

    public enum Action {
        case task

        case appartementList(AppartementListFeature.Action)
    }

    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                return .run { send in
                    let mockApp = Appartement(id: "123", hostUserId: "", title: "Favourite", city: "M", countryCode: "B", pricePerNight: 125, guestCount: 4)
                    // TODO: load favourites appartements
                    await send(.appartementList(.appartementsChanged([mockApp])))
                }
            case .appartementList:
                return .none
            }
        }

        Scope(state: \.appartementList, action: \.appartementList) {
            AppartementListFeature()
        }
    }
}
