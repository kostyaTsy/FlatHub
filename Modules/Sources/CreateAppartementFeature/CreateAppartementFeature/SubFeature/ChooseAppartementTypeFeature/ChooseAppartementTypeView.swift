//
//  ChooseAppartementTypeView.swift
//
//
//  Created by Kostya Tsyvilko on 17.04.24.
//

import SwiftUI
import ComposableArchitecture

struct ChooseAppartementTypeView: View {
    @Perception.Bindable private var store: StoreOf<ChooseAppartementTypeFeature>

    init(store: StoreOf<ChooseAppartementTypeFeature>) {
        self.store = store
    }

    var body: some View {
        Text("")
    }
}

#Preview {
    ChooseAppartementTypeView(
        store: .init(
            initialState: .init(), reducer: {
                ChooseAppartementTypeFeature()
            }
        )
    )
}
