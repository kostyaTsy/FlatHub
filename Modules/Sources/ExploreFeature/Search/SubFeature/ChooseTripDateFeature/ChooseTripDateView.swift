//
//  ChooseTripDateView.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct ChooseTripDateView: View {
    @Perception.Bindable private var store: StoreOf<ChooseTripDateFeature>

    init(store: StoreOf<ChooseTripDateFeature>) {
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
                Text(Strings.whenText)
                Spacer()
                Text(store.selectedDatesRange)
            }
            Divider()
        }
    }

    @ViewBuilder private func collapsableContainerContent() -> some View {
        VStack {
            chooseDateCell(
                title: Strings.searchStartDate,
                date: $store.startDate.sending(\.onChangeStartDate),
                in: Date()...
            )

            chooseDateCell(
                title: Strings.searchEndDate,
                date: $store.endDate.sending(\.onChangeEndDate),
                in: store.startDate...
            )
        }
    }

    @ViewBuilder private func chooseDateCell(
        title: String,
        date: Binding<Date>,
        in range: PartialRangeFrom<Date>
    ) -> some View {
        DatePicker(
            title,
            selection: date,
            in: range,
            displayedComponents: [.date]
        )
        .datePickerStyle(.automatic)
    }
}

#if DEBUG
    #Preview {
        ChooseTripDateView(
            store: .init(
                initialState: .init(), reducer: {
                    ChooseTripDateFeature()
                }
            )
        )
    }
#endif
