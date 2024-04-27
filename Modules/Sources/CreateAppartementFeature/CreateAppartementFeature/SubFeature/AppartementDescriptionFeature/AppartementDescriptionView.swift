//
//  AppartementDescriptionView.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct AppartementDescriptionView: View {
    @Perception.Bindable private var store: StoreOf<AppartementDescriptionFeature>

    init(store: StoreOf<AppartementDescriptionFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
                .background(Colors.system)
                .onTapGesture {
                    hideKeyboard()
                }
                .onDisappear {
                    hideKeyboard()
                }
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(
            title: Strings.appartementDescriptionTitle,
            subtitle: Strings.appartementDescriptionSubtitle
        ) {
            VStack {
                TextField(
                    Strings.appartementDescriptionTextFieldPlaceholder,
                    text: $store.description.sending(\.onDescriptionChanged),
                    axis: .vertical
                )
                .lineLimit(Constants.textFieldLines, reservesSpace: true)
                .textFieldStyle(.roundedBorder)

                Spacer()
            }

        }
        .padding(.top, Layout.Spacing.medium)
    }
}

private extension AppartementDescriptionView {
    enum Constants {
        static let textFieldLines = 6
    }
}

#if DEBUG
    #Preview {
        AppartementDescriptionView(
            store: .init(
                initialState: .init(), reducer: {
                    AppartementDescriptionFeature()
                }
            )
        )
    }
#endif
