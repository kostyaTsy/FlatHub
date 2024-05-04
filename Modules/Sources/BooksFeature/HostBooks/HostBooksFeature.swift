//
//  HostBooksFeature.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import AppartementListFeature
import FHRepository

@Reducer
public struct HostBooksFeature {
    @ObservableState
    public struct State {
        var bookList = BookListFeature.State(books: [])
        public init() {}
    }

    public enum Action {
        case onAppear
        case bookList(BookListFeature.Action)
    }

    @Dependency(\.bookAppartementRepository) var bookAppartementRepository
    @Dependency(\.accountRepository) var accountRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let user = accountRepository.user()
                    let bookedAppartements = (try? await bookAppartementRepository.loadHostUserBooks(user.id)) ?? []
                    let books = bookedAppartements.map { BookListMapper.mapToBookModel(from: $0) }
                    await send(.bookList(.setBooksData(books)))
                }
            case .bookList:
                return .none
            }
        }

        Scope(state: \.bookList, action: \.bookList) {
            BookListFeature()
        }
    }
}
