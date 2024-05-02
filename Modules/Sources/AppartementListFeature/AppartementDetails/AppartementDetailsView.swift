//
//  AppartementDetailsView.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct AppartementDetailsView: View {
    @Perception.Bindable private var store: StoreOf<AppartementDetailsFeature>

    init(store: StoreOf<AppartementDetailsFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .alert(
                    $store.scope(
                        state: \.destination?.errorAlert,
                        action: \.destination.errorAlert
                    )
                )
                .alert(
                    $store.scope(
                        state: \.destination?.cancelBookingAlert,
                        action: \.destination.cancelBookingAlert
                    )
                )
                .sheet(
                    item: $store.scope(
                        state: \.destination?.selectDates,
                        action: \.destination.selectDates
                    )
                ) { store in
                    SelectBookDatesView(store: store)
                        .presentationDetents([.fraction(Constants.selectDatesSheetFraction)])
                }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder private func content() -> some View {
        VStack {
            // Header
            // Content
            Text(store.appartement.title)
            // Footer
            footerView()
        }
    }

    @ViewBuilder private func footerView() -> some View {
        if store.presentationType.shouldShowBookButton {
            FHOvalButton(
                title: Strings.bookButtonTitle
            ) {
                store.send(.onBookTapped)
            }
        } else if store.presentationType.shouldShowCancelBookButton {
            FHOvalButton(
                title: Strings.cancelBookButtonTitle
            ) {
                store.send(.onCancelBookTapped)
            }
        }
    }
}

private extension AppartementDetailsView {
    enum Constants {
        static let selectDatesSheetFraction: CGFloat = 0.25
    }
}

#if DEBUG
    #Preview {
        let appartement = AppartementModel(
            id: "123",
            hostUserId: "012",
            title: "Test title",
            city: "Minsk",
            countryCode: "BY",
            pricePerNight: 20, guestCount: 3
        )
        return AppartementDetailsView(
            store: .init(
                initialState: .init(appartement: appartement), reducer: {
                    AppartementDetailsFeature()
                }
            )
        )
    }
#endif
