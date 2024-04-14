//
//  HostBooksView.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import ComposableArchitecture
import SwiftUI

public struct HostBooksView: View {
    @Perception.Bindable private var store: StoreOf<HostBooksFeature>

    public init(store: StoreOf<HostBooksFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            Text("Host Books")
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
