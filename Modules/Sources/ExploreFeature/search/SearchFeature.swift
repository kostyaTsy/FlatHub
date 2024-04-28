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
        var chooseCity = ChooseCityFeature.State()
        var chooseDates = ChooseTripDateFeature.State()
        var chooseGuests = ChooseTravellersFeature.State()

        public init() {}
    }

    public enum Action {
        case onAppear
        case closeIconTapped
        case onApplyTapped
        case searchData(SearchModel)
        case chooseCity(ChooseCityFeature.Action)
        case chooseDates(ChooseTripDateFeature.Action)
        case chooseGuests(ChooseTravellersFeature.Action)
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.chooseCity.isCollapsed = false
                return .none
            case .closeIconTapped:
                let model = SearchModel(
                    city: state.chooseCity.selectedCity,
                    countryCode: state.chooseCity.selectedCountryCode,
                    startDate: state.chooseDates.startDate,
                    endDate: state.chooseDates.endDate,
                    guestsCount: state.chooseGuests.guestsCount
                )
                return .run { send in
                    await send(.searchData(model))
                    await dismiss()
                }
            case .onApplyTapped:
                return .run { send in
                    await dismiss()
                }
            case .chooseCity, .chooseDates, .chooseGuests, .searchData:
                return .none
            }
        }

        Scope(state: \.chooseCity, action: \.chooseCity) {
            ChooseCityFeature()
        }

        Scope(state: \.chooseDates, action: \.chooseDates) {
            ChooseTripDateFeature()
        }

        Scope(state: \.chooseGuests, action: \.chooseGuests) {
            ChooseTravellersFeature()
        }
    }
}
