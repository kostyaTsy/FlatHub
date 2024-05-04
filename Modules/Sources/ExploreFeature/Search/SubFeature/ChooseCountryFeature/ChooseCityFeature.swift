//
//  ChooseCityFeature.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct ChooseCityFeature {
    @ObservableState
    public struct State {
        var isCollapsed: Bool = true
        var searchText: String = ""
        var selectedCityResult: SearchCity?

        var searchResult: [SearchCity] = []

        var selectedCity: String {
            selectedCityResult?.city ?? searchText
        }

        var selectedCountryCode: String? {
            selectedCityResult?.countryCode
        }

        public init() {}
    }

    public enum Action {
        case onChangeCollapse(Bool)
        case onChangeSearchText(String)
        case performSearch(String)
        case searchResponse([SearchCity])
        case onChoseLocation(SearchCity)
    }

    @Dependency(\.geolocationRepository) var geolocationRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onChangeCollapse(let isCollapsed):
                state.isCollapsed = isCollapsed
                return .none
            case .onChangeSearchText(let text):
                state.searchText = text
                if text.isEmpty {
                    return .none
                }
                return .send(.performSearch(text))
            case .performSearch(let query):
                return .run { send in
                    let searchResponse = (try? await geolocationRepository.searchCity(query)) ?? []
                    let searchResult = searchResponse.map { SearchMapper.mapToSearchCity(from: $0) }
                    await send(.searchResponse(searchResult))
                }
            case .searchResponse(let searchResponse):
                state.searchResult = searchResponse
                return .none
            case .onChoseLocation(let searchModel):
                state.searchText = searchModel.city
                state.selectedCityResult = searchModel
                return .none
            }
        }
    }
}
