//
//  EarningsView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import SwiftUI

public struct EarningsView: View {
    @Perception.Bindable private var store: StoreOf<EarningsFeature>

    public init(store: StoreOf<EarningsFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            Text("Earnings")
        }
    }
}

#if DEBUG
    #Preview {
        EarningsView(
            store: .init(
                initialState: .init(), reducer: {
                    EarningsFeature()
                }
            )
        )
    }
#endif
