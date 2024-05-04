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
        case onSearchStart(SearchModel)
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
                return .run { [searchModel = state.searchModel] send in
                    if let searchModel {
                        await send(.onSearchStart(searchModel))
                        return
                    }
                    let data = await loadAppartements()
                    await send(.appartementList(.setAppartementsData(data)))
                }
            case .search(.presented(.searchData(let searchModel))):
                state.searchModel = searchModel
                return .send(.onSearchStart(searchModel))
            case .onSearchStart(let searchModel):
                return .run { send in
                    let userId = accountRepository.user().id
                    let searchDTO = ExploreMapper.mapToSearchDTO(from: searchModel)
                    let appartements = (try? await appartementRepository.searchAppartements(userId, searchDTO)) ?? []
                    let appartementList = appartements.map { AppartementMapper.mapToAppartementModel(from: $0) }
                    let data = AppartementMapper.mapToAppartementsData(
                        with: appartementList,
                        startSearchDate: searchModel.startDate,
                        endSearchDate: searchModel.endDate
                    )
                    await send(.appartementList(.setAppartementsData(data)))
                }
            case .search(.presented(.onResetTapped)):
                state.searchModel = nil
                return .run { send in
                    let data = await loadAppartements()
                    await send(.appartementList(.setAppartementsData(data)))
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
    func loadAppartements() async -> AppartementsData {
        let userId = accountRepository.user().id
        let appartements = (try? await appartementRepository.loadAppartements(userId)) ?? []
        let appartementList = appartements.map { AppartementMapper.mapToAppartementModel(from: $0) }
        return AppartementMapper.mapToAppartementsData(with: appartementList)
    }
}
