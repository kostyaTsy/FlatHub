//
//  UserBooksView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture
import AppartementListFeature
import FHCommon

public struct UserBooksView: View {
    private let store: StoreOf<UserBooksFeature>

    public init(store: StoreOf<UserBooksFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            contentView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            store.send(.task)
        }
    }

    @ViewBuilder private func contentView() -> some View {
        FHContentView(
            title: Strings.booksTabTitle,
            configuration: .init(
                horizontalPadding: Layout.Spacing.smallMedium
            )
        ) {
            VStack {
                Spacer()
                BookList(
                    store: store.scope(
                        state: \.bookList,
                        action: \.bookList
                    )
                )
                Spacer()
            }
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
