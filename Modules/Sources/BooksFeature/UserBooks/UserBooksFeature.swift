//
//  UserBooksFeature.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import ComposableArchitecture
import AppartementListFeature
import FHRepository

@Reducer
public struct UserBooksFeature {
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
                    // TODO: load favourites appartements
                    let mockApp = AppartementModel(id: "123", hostUserId: "", title: "Booked", city: "M", countryCode: "B", pricePerNight: 125, guestCount: 4)
                    let data = AppartementsData(appartements: [mockApp])
                    await send(.appartementList(.setAppartementsData(data)))
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
