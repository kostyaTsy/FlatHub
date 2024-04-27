//
//  ChooseGuestsCountView.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct ChooseGuestsCountView: View {
    @Perception.Bindable private var store: StoreOf<ChooseGuestsCountFeature>

    init(store: StoreOf<ChooseGuestsCountFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(title: Strings.chooseGuestsCountTitle) {
            VStack {
                chooseItemsList()
                Spacer()
            }
        }
        .padding(.top, Layout.Spacing.medium)
    }

    @ViewBuilder private func chooseItemsList() -> some View {
        VStack {
            chooseItemCell(
                title: Strings.guestsText,
                value: $store.guestsCount.sending(\.onGuestsCountChanged),
                range: Constants.guestsCountRange
            )
            Divider()
            chooseItemCell(
                title: Strings.bedroomsText,
                value: $store.bedroomsCount.sending(\.onBedroomsCountChanged),
                range: Constants.bedroomsCountRange
            )
            Divider()
            chooseItemCell(
                title: Strings.bedsText,
                value: $store.bedsCount.sending(\.onBedsCountChanged),
                range: Constants.bedsCountRange
            )
            Divider()
            chooseItemCell(
                title: Strings.bathroomsText,
                value: $store.bathroomsCount.sending(\.onBathroomsCountChanged),
                range: Constants.bathroomsCountRange
            )
        }
    }

    @ViewBuilder private func chooseItemCell(
        title: String,
        value: Binding<Int>,
        range: ClosedRange<Int> = 1...5
    ) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value.wrappedValue)")

            Stepper(value: value, in: range) { }
                .frame(width: Constants.stepperWidth)
        }
    }
}

private extension ChooseGuestsCountView {
    enum Constants {
        static let stepperWidth: CGFloat = 100

        static let guestsCountRange = 1...16
        static let bedroomsCountRange = 0...10
        static let bedsCountRange = 1...20
        static let bathroomsCountRange = 1...5
    }
}

#if DEBUG
    #Preview {
        ChooseGuestsCountView(
            store: .init(
                initialState: .init(), reducer: {
                    ChooseGuestsCountFeature()
                }
            )
        )
    }
#endif
