//
//  SearchFeature.swift
//
//
//  Created by Kostya Tsyvilko on 27.04.24.
//

import ComposableArchitecture

@Reducer
public struct SearchFeature {
    @ObservableState
    public struct State {
        var chooseCountry = ChooseCountryFeature.State()
        var chooseDates = ChooseTripDateFeature.State()
        var chooseGuests = ChooseTravellersFeature.State()

        public init() {}
    }

    public enum Action {
        case onAppear
        case closeIconTapped
        case onApplyTapped
        case chooseCountry(ChooseCountryFeature.Action)
        case chooseDates(ChooseTripDateFeature.Action)
        case chooseGuests(ChooseTravellersFeature.Action)
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.chooseCountry.isCollapsed = false
                return .none
            case .closeIconTapped:
                return .run { send in
                    await dismiss()
                }
            case .onApplyTapped:
                return .run { send in
                    await dismiss()
                }
            case .chooseCountry, .chooseDates, .chooseGuests:
                return .none
            }
        }

        Scope(state: \.chooseCountry, action: \.chooseCountry) {
            ChooseCountryFeature()
        }

        Scope(state: \.chooseDates, action: \.chooseDates) {
            ChooseTripDateFeature()
        }

        Scope(state: \.chooseGuests, action: \.chooseGuests) {
            ChooseTravellersFeature()
        }
    }
}
