//
//  AddRatingView.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct AddRatingView: View {
    @Perception.Bindable private var store: StoreOf<AddRatingFeature>

    init(store: StoreOf<AddRatingFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
        }
    }

    @ViewBuilder private func content() -> some View {
        VStack {
            headerView()
                .padding([.horizontal, .top], Layout.Spacing.smallMedium)
            reviewContent()
        }
    }

    @ViewBuilder private func headerView() -> some View {
        HStack {
            Button {
                store.send(.onCloseIconTapped)
            } label: {
                Icons.closeIcon
                    .font(.title)
                    .foregroundStyle(Colors.lightGray)
            }

            Spacer()
        }
    }

    @ViewBuilder private func reviewContent() -> some View {
        ScrollView {
            VStack {
                ReviewContainer(
                    title: Strings.reviewAppartementTitle,
                    chosenRate: $store.appartementRating.sending(\.onAppartementRatingChange),
                    placeholder: Strings.reviewAppartementPlaceholder,
                    text: $store.appartementReviewText.sending(\.onAppartementReviewTextChange)
                )

                Divider()

                ReviewContainer(
                    title: Strings.reviewHostTitle,
                    chosenRate: $store.hostRating.sending(\.onHostRatingChange),
                    placeholder: Strings.reviewHostPlaceholder,
                    text: $store.hostReviewText.sending(\.onHostReviewTextChange)
                )

                if store.isLoading {
                    ProgressView()
                }

                FHOvalButton(
                    title: Strings.reviewButtonTitle,
                    disabled: store.isLoading
                ) {
                    store.send(.onReviewButtonTapped)
                }
                .padding(.horizontal, Layout.Spacing.smallMedium)
            }
        }
    }
}

#if DEBUG
    #Preview {
        AddRatingView(
            store: .init(
                initialState: .init(
                    dataModel: AddRatingModel(appartementId: "", hostUserId: "")
                ),
                reducer: {
                    AddRatingFeature()
                }
            )
        )
    }
#endif
