//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import ComposableArchitecture
import AppartementListFeature
import FHRepository

@Reducer
public struct FavouritesFeature {
    @ObservableState
    public struct State {
        var appartementList = AppartementListFeature.State(appartements: [])
        public init() {}
    }

    public enum Action {
        case task
        case appartementList(AppartementListFeature.Action)
    }

    @Dependency(\.accountRepository) var accountRepository
    @Dependency(\.appartementRepository) var appartementRepository

    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                return .run { send in
                    let userId = accountRepository.user().id
                    let appartements = (try? await appartementRepository.loadFavouriteAppartements(userId)) ?? []
                    let appartementList = appartements.map { AppartementMapper.mapToAppartementModel(from: $0) }
                    let data = AppartementMapper.mapToAppartementsData(with: appartementList)
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
