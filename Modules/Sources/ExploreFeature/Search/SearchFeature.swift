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
        var searchModel: SearchModel?

        public init(searchModel: SearchModel? = nil) {
            self.searchModel = searchModel
        }
    }

    public enum Action {
        case onAppear
        case closeIconTapped
        case onApplyTapped
        case onResetTapped
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
                let searchModel = state.searchModel
                state.chooseCity.isCollapsed = false
                guard let searchModel else {
                    return .none
                }

                state.chooseCity.searchText = searchModel.city
                state.chooseCity.selectedCityResult = SearchCity(
                    city: searchModel.city,
                    countryCode: searchModel.countryCode ?? ""
                )

                state.chooseDates.startDate = searchModel.startDate
                state.chooseDates.endDate = searchModel.endDate

                state.chooseGuests.guestsCount = searchModel.guestsCount
                return .none
            case .closeIconTapped:
                return .run { send in
                    await dismiss()
                }
            case .onResetTapped:
                return .run { send in
                    await dismiss()
                }
            case .onApplyTapped:
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
