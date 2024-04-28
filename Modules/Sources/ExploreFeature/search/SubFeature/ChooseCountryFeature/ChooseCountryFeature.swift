//
//  ChooseCountryFeature.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct ChooseCountryFeature {
    @ObservableState
    public struct State {
        var isCollapsed: Bool = true
        var searchText: String = ""

        var searchResult: [SearchCity] = []

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
                return .none
            }
        }
    }
}
