//
//  ChooseAppartementTypeView.swift
//
//
//  Created by Kostya Tsyvilko on 17.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct ChooseAppartementTypeView: View {
    @Perception.Bindable private var store: StoreOf<ChooseAppartementTypeFeature>

    init(store: StoreOf<ChooseAppartementTypeFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(title: Strings.chooseAppartementTypeTitle) {
            FHItemCollection(
                items: store.items,
                configuration: .init(supportMultipleSelection: false)
            ) { item in
                store.send(.onSelectionChange(item))
            }
        }
        .padding(.top, Layout.Spacing.medium)
    }
}

#if DEBUG
    #Preview {
        ChooseAppartementTypeView(
            store: .init(
                initialState: .init(), reducer: {
                    ChooseAppartementTypeFeature()
                }
            )
        )
    }
#endif
