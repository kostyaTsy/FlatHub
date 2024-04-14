//
//  ListingsView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import SwiftUI

public struct ListingsView: View {
    @Perception.Bindable private var store: StoreOf<ListingsFeature>

    public init(store: StoreOf<ListingsFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            Text("Listings")
        }
    }
}

#if DEBUG
    #Preview {
        ListingsView(
            store: .init(
                initialState: .init(), reducer: {
                    ListingsFeature()
                }
            )
        )
    }
#endif
