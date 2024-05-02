//
//  SelectBookDatesView.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct SelectBookDatesView: View {
    @Perception.Bindable private var store: StoreOf<SelectBookDatesFeature>

    init(store: StoreOf<SelectBookDatesFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(Layout.Spacing.smallMedium)
        }
    }

    @ViewBuilder private func content() -> some View {
        VStack {
            // TODO: improve date selection without booked days
            chooseDateCell(
                title: Strings.searchStartDate,
                date: $store.startDate.sending(\.onStartDateChange),
                in: Date()...
            )

            chooseDateCell(
                title: Strings.searchEndDate,
                date: $store.endDate.sending(\.onEndDateChange),
                in: store.startDate...
            )

            FHOvalButton(
                title: Strings.searchApplyButtonTitle
            ) {
                store.send(.onApplyTapped)
            }
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
        SelectBookDatesView(
            store: .init(
                initialState: .init(appartementId: ""), reducer: {
                    SelectBookDatesFeature()
                }
            )
        )
    }
#endif
