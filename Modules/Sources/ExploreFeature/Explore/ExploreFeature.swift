//
//  ExploreFeature.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import ComposableArchitecture
import AppartementListFeature
import FHRepository

@Reducer
public struct ExploreFeature {
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
                    try? await Task.sleep(for: .seconds(2))
                    let mockApps = Array(0...10).map { id in
                        Appartement(id: "\(id)", hostUserId: "", title: "Test", city: "M", countryCode: "B", pricePerNight: 125, guestCount: 4)
                    }
                    // TODO: load appartements
                    await send(.appartementList(.appartementsChanged(mockApps)))
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
