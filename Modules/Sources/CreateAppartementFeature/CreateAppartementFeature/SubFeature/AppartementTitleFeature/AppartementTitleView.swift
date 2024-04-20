//
//  AppartementTitleView.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct AppartementTitleView: View {
    @Perception.Bindable private var store: StoreOf<AppartementTitleFeature>

    init(store: StoreOf<AppartementTitleFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(
            title: Strings.appartementTitleText,
            subtitle: Strings.appartementTitleSubtext
        ) {
            VStack {
                TextField(
                    Strings.appartementTitleTextFieldPlaceholder,
                    text: $store.title.sending(\.onTitleChanged),
                    axis: .vertical
                )
                .lineLimit(Constants.textFieldLines, reservesSpace: true)
                .textFieldStyle(.roundedBorder)

                Spacer()
            }

        }
    }
}

private extension AppartementTitleView {
    enum Constants {
        static let textFieldLines = 4
    }
}

#if DEBUG
    #Preview {
        AppartementTitleView(
            store: .init(
                initialState: .init(), reducer: {
                    AppartementTitleFeature()
                }
            )
        )
    }
#endif
