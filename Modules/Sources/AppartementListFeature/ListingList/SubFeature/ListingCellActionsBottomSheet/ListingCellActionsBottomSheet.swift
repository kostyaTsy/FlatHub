//
//  ListingCellActionsBottomSheet.swift
//
//
//  Created by Kostya Tsyvilko on 23.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct ListingCellActionsBottomSheet: View {
    @Perception.Bindable private var store: StoreOf<ListingCellActionsBottomSheetFeature>

    init(store: StoreOf<ListingCellActionsBottomSheetFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: .zero) {
                FHOvalButton(
                    title: Strings.editAppartementButtonTitle,
                    configuration: Constants.buttonConfiguration
                ) {
                    store.send(.onEdit)
                }

                FHOvalButton(
                    title: Strings.deleteAppartementButtonTitle,
                    configuration: Constants.buttonConfiguration
                ) {
                    store.send(.onDelete)
                }

                FHOvalButton(
                    title: store.appartement.isAvailableForBook ? Strings.changeAvailabilityToOfflineButtonTitle : Strings.changeAvailabilityToOnlineButtonTitle,
                    configuration: Constants.buttonConfiguration
                ) {
                    store.send(.onChangeAvailability)
                }
            }
            .padding(Layout.Spacing.smallMedium)
            .frame(maxWidth: .infinity)
        }
    }
}

private extension ListingCellActionsBottomSheet {
    enum Constants {
        static let buttonConfiguration = FHOvalButton.Configuration(
            backgroundColor: .secondary,
            foregroundColor: Colors.system
        )
    }
}
