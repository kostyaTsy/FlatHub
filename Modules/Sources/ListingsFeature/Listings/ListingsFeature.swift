//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import CreateAppartementFeature
import AppartementListFeature
import FHRepository

@Reducer
public struct ListingsFeature {
    @ObservableState
    public struct State {
        var path = StackState<Path.State>()
        var listings = ListingListFeature.State(appartements: [])

        public init() {}
    }

    public enum Action {
        case onAppear
        case onAppartementsLoaded([AppartementDetailsDTO])
        case addButtonTapped
        case listings(ListingListFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
    }

    @Reducer
    public enum Path {
        case create(CreateAppartementFeature)
    }

    @Dependency(\.appartementRepository) var appartementRepository
    @Dependency(\.accountRepository) var accountRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let user = accountRepository.user()
                    do {
                        let appartements = try await appartementRepository.loadHostAppartements(user.id)
                        await send(.onAppartementsLoaded(appartements))
                    } catch {}
                }
            case .onAppartementsLoaded(let appartementsDTO):
                let appartements = appartementsDTO.map {
                    ListingsMapper.mapToHostAppartement(from: $0)
                }
                return .send(.listings(.setAppartements(appartements)))
            case .addButtonTapped:
                state.path.append(.create(.init()))
                return .none
            case .path, .listings:
                return .none
            }
        }
        .forEach(\.path, action: \.path)

        Scope(state: \.listings, action: \.listings) {
            ListingListFeature()
        }
    }
}
