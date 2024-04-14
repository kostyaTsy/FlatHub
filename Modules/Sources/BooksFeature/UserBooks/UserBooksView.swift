//
//  UserBooksView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture
import AppartementListFeature

public struct UserBooksView: View {
    private let store: StoreOf<UserBooksFeature>

    public init(store: StoreOf<UserBooksFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            contentView()
        }
        .task {
            store.send(.task)
        }
    }

    @ViewBuilder private func contentView() -> some View {
        VStack {
            AppartementList(
                store: store.scope(
                    state: \.appartementList,
                    action: \.appartementList
                )
            )
        }
    }
}

#if DEBUG
    #Preview {
        UserBooksView(
            store: .init(
                initialState: .init(), reducer: {
                    UserBooksFeature()
                }
            )
        )
    }
#endif
