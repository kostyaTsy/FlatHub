//
//  ChooseDescriptionTypesView.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct ChooseDescriptionTypesView: View {
    @Perception.Bindable private var store: StoreOf<ChooseDescriptionTypesFeature>

    init(store: StoreOf<ChooseDescriptionTypesFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(title: Strings.chooseDescriptionTypesTitle) {
            FHItemCollection(
                items: store.items,
                configuration: .init(
                    presentationType: .compact,
                    supportMultipleSelection: true
                )
            ) { item in
                store.send(.onSelectionChange(item))
            }
        }
        .padding(.top, Layout.Spacing.medium)
    }
}

#if DEBUG
    #Preview {
        ChooseDescriptionTypesView(
            store: .init(
                initialState: .init(), reducer: {
                    ChooseDescriptionTypesFeature()
                }
            )
        )
    }
#endif
