//
//  SearchView.swift
//
//
//  Created by Kostya Tsyvilko on 27.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct SearchView: View {
    @Perception.Bindable private var store: StoreOf<SearchFeature>

    @State var collapsed: Bool = true

    public init(store: StoreOf<SearchFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
        }
    }

    @ViewBuilder private func content() -> some View {
        CollapsableContainer(collapsed: $collapsed) {
            Text("123")
        } content: {
            Text("123")
        }

    }
}

#if DEBUG
    #Preview {
        SearchView(
            store: .init(
                initialState: .init(), reducer: {
                    SearchFeature()
                }
            )
        )
    }
#endif
