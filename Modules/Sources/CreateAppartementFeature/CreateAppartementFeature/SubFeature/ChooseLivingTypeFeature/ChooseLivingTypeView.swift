//
//  ChooseLivingTypeView.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct ChooseLivingTypeView: View {
    @Perception.Bindable private var store: StoreOf<ChooseLivingTypeFeature>

    init(store: StoreOf<ChooseLivingTypeFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(title: Strings.chooseLivingTypeTitle) {
            FHItemCollection(
                items: store.items,
                configuration: .init(
                    presentationType: .full, 
                    supportMultipleSelection: false
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
        ChooseLivingTypeView(
            store: .init(
                initialState: .init(), reducer: {
                    ChooseLivingTypeFeature()
                }
            )
        )
    }
#endif
