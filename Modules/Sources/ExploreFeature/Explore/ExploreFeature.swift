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
        var searchModel: SearchModel?
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
                    let appartementList = await loadAppartements()
                    await send(.appartementList(.appartementsChanged(appartementList)))
                }
            case .search(.presented(.searchData(let searchModel))):
                state.searchModel = searchModel
                return .run { send in
                    let userId = accountRepository.user().id
                    let searchDTO = ExploreMapper.mapToSearchDTO(from: searchModel)
                    let appartements = (try? await appartementRepository.searchAppartements(userId, searchDTO)) ?? []
                    let appartementList = appartements.map { AppartementMapper.mapToAppartementModel(from: $0) }
                    await send(.appartementList(.appartementsChanged(appartementList)))
                }
            case .search(.presented(.onResetTapped)):
                state.searchModel = nil
                return .run { send in
                    let appartementList = await loadAppartements()
                    await send(.appartementList(.appartementsChanged(appartementList)))
                }
            case .onSearchContainerTaped:
                state.search = .init(searchModel: state.searchModel)
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

private extension ExploreFeature {
    func loadAppartements() async -> [AppartementModel] {
        let userId = accountRepository.user().id
        let appartements = (try? await appartementRepository.loadAppartements(userId)) ?? []
        return appartements.map { AppartementMapper.mapToAppartementModel(from: $0) }
    }
}
