//
//  ChooseTravellersView.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct ChooseTravellersView: View {
    @Perception.Bindable private var store: StoreOf<ChooseTravellersFeature>

    init(store: StoreOf<ChooseTravellersFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
        }
    }

    @ViewBuilder private func content() -> some View {
        CollapsableContainer(
            collapsed: $store.isCollapsed.sending(\.onChangeCollapse)
        ) {
            collapsableContainerHeader()
                .padding(.horizontal, Layout.Spacing.smallMedium)
                .padding(.vertical, Layout.Spacing.small)
        } content: {
            collapsableContainerContent()
                .padding(.horizontal, Layout.Spacing.smallMedium)
                .padding(.vertical, Layout.Spacing.small)
        }
    }

    @ViewBuilder private func collapsableContainerHeader() -> some View {
        VStack {
            HStack {
                Text(Strings.whoText)
                Spacer()
                Text("\(Strings.guestsText) - \(store.guestsCount)")
            }
            Divider()
        }
    }

    @ViewBuilder private func collapsableContainerContent() -> some View {
        chooseItemCell(
            title: Strings.guestsText,
            value: $store.guestsCount.sending(\.onChangeGuestsCount),
            range: Constants.guestsCountRange
        )
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

private extension ChooseTravellersView {
    enum Constants {
        static let stepperWidth: CGFloat = 100

        static let guestsCountRange = 1...16
    }
}

#if DEBUG
    #Preview {
        ChooseTravellersView(
            store: .init(
                initialState: .init(), reducer: {
                    ChooseTravellersFeature()
                }
            )
        )
    }
#endif
