//
//  HostBooksView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import SwiftUI
import AppartementListFeature
import FHCommon

public struct HostBooksView: View {
    @Perception.Bindable private var store: StoreOf<HostBooksFeature>

    public init(store: StoreOf<HostBooksFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            contentView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .task {
            store.send(.onAppear)
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
            .frame(maxWidth: .infinity)
        }
    }
}

#if DEBUG
    #Preview {
        HostBooksView(
            store: .init(
                initialState: .init(), reducer: {
                    HostBooksFeature()
                }
            )
        )
    }
#endif
