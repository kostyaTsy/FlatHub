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
        @Presents var search: SearchFeature.State?
        public init() {}
    }

    public enum Action {
        case task
        case onSearchContainerTaped
        case search(PresentationAction<SearchFeature.Action>)
        case appartementList(AppartementListFeature.Action)
    }

    @Dependency(\.appartementRepository) var appartementRepository
    @Dependency(\.accountRepository) var accountRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                return .run { send in
                    let userId = accountRepository.user().id
                    let appartements = (try? await appartementRepository.loadAppartements(userId)) ?? []
                    let appartementList = appartements.map { AppartementMapper.mapToAppartementModel(from: $0) }
                    await send(.appartementList(.appartementsChanged(appartementList)))
                }
            case .search(.presented(.searchData(let searchModel))):
                print(searchModel)
                // TODO: Load appartement
                return .none
            case .onSearchContainerTaped:
                state.search = .init()
                return .none
            case .appartementList, .search:
                return .none
            }
        }
        .ifLet(\.$search, action: \.search) {
            SearchFeature()
        }

        Scope(state: \.appartementList, action: \.appartementList) {
            AppartementListFeature()
        }
    }
}
