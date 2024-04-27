//
//  ChooseOfferTypesView.swift
//  
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct ChooseOfferTypesView: View {
    @Perception.Bindable private var store: StoreOf<ChooseOfferTypesFeature>

    init(store: StoreOf<ChooseOfferTypesFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(title: Strings.chooseOfferTypesTitle) {
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
        ChooseOfferTypesView(
            store: .init(
                initialState: .init(), reducer: {
                    ChooseOfferTypesFeature()
                }
            )
        )
    }
#endif
