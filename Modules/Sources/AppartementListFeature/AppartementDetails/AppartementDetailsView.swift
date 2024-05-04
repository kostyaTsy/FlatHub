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
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    toolbarContent()
                }
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
                .sheet(
                    item: $store.scope(
                        state: \.destination?.addReview,
                        action: \.destination.addReview
                    )
                ) { store in
                    AddRatingView(store: store)
                }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder private func content() -> some View {
        VStack {
            ScrollView {
                // Header
                headerView()
                // Content
                AppartementDetailsContent(
                    appartementModel: store.appartement,
                    appartementInfoModel: store.details
                )
            }
            // Footer
            footerView()
        }
        .ignoresSafeArea(edges: .top)
    }

    @ToolbarContentBuilder private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                store.send(.onBackButtonTapped)
            } label: {
                Icons.chevronLeft
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: Constants.headerIconSize)
                    .padding(.all, Layout.Spacing.small)
                    .foregroundStyle(Colors.system)
                    .background(Colors.secondary)
                    .clipShape(Circle())
            }
            .foregroundStyle(Colors.label)
        }

        if store.presentationType.shouldShowFavouriteButton {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.onFavouriteButtonTapped)
                } label: {
                    Image(systemName: store.appartement.isFavourite ? Icons.favouriteFillIconName : Icons.favouriteIconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Constants.headerIconSize)
                        .padding(.all, 7)
                        .foregroundStyle(store.appartement.isFavourite ? .red : Colors.system)
                        .background(Colors.secondary)
                        .clipShape(Circle())
                }
                .foregroundStyle(Colors.label)
            }
        }
    }

    @ViewBuilder private func headerView() -> some View {
        AppartementDetailsPhotoSlider(
            photos: store.appartement.photos
        )
    }

    @ViewBuilder private func footerView() -> some View {
        HStack {
            if store.presentationType.shouldShowBookButton {
//                FHOvalButton(
//                    title: Strings.bookButtonTitle
//                ) {
//                    store.send(.onBookTapped)
//                }
                bookButton()
            } else if store.presentationType.shouldShowCancelBookButton {
                FHOvalButton(
                    title: Strings.cancelBookButtonTitle
                ) {
                    store.send(.onCancelBookTapped)
                }
            } else if store.presentationType.shouldShowReviewButton {
                FHOvalButton(
                    title: Strings.addReviewButtonTitle
                ) {
                    store.send(.onAddReviewTapped)
                }
            }
        }
        .padding(.horizontal, Layout.Spacing.smallMedium)
    }

    @ViewBuilder private func bookButton() -> some View {
        HStack {
            if let bookingDates = store.searchBookingDates {
                VStack(alignment: .leading) {
                    Text(bookingDates)
                        .padding(.bottom, Layout.Spacing.xSmall)

                    Text("\(store.searchBookingDatesPrice)\(Strings.currencySign)")
                        .font(Constants.priceFont)
                        .foregroundStyle(Colors.lightGray)
                }
            } else {
                Text("\(store.appartement.pricePerNight)\(Strings.currencySign)")
                    .font(Constants.priceFont)
                    .foregroundStyle(Colors.lightGray)
            }

            Spacer()

            FHOvalButton(
                title: Strings.bookButtonTitle
            ) {
                store.send(.onBookTapped)
            }
            .frame(width: Constants.bookButtonWidth)
        }
    }
}

private extension AppartementDetailsView {
    enum Constants {
        static let selectDatesSheetFraction: CGFloat = 0.25
        static let headerIconSize: CGFloat = 15
        static let priceFont = Font.system(size: 16, weight: .medium)
        static let bookButtonWidth: CGFloat = 100
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
        return NavigationStack {
            AppartementDetailsView(
                store: .init(
                    initialState: .init(appartement: appartement), reducer: {
                        AppartementDetailsFeature()
                    }
                )
            )
        }
    }
#endif
