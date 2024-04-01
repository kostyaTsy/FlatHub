//
//  AppartementList.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import SwiftUI
import ComposableArchitecture
import FHRepository
import FHCommon

public struct AppartementList: View {
    @Perception.Bindable private var store: StoreOf<AppartementListFeature>

    public init(store: StoreOf<AppartementListFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            if !store.isDataLoaded {
                ProgressView(Strings.loadingText)
            } else if store.isDataLoaded && store.appartements.isEmpty {
                Text(Strings.noDataText)
            } else {
                appartementListContent()
            }
        }
        .padding(.horizontal, Layout.Spacing.medium)
    }

    @ViewBuilder private func appartementListContent() -> some View {
        ScrollView() {
            LazyVStack(spacing: Layout.Spacing.big50) {
                ForEach(store.appartements, id: \.id) { item in
                    AppartementCell(appartement: item) {
                        store.send(.onFavouriteButtonTapped(item))
                    }
                    .onTapGesture {
                        store.send(.onAppartementTapped(item))
                    }
                }
            }
        }
        .scrollIndicators(.never)
    }
}

private extension AppartementList {
    enum Constants {
        static let appartementItemsSpacing: CGFloat = 20
    }
}

#if DEBUG
    #Preview {
        let mockAppartement = Appartement(
            id: "",
            hostUserId: "",
            title: "Tiny house",
            city: "Minsk",
            countryCode: "BY",
            pricePerNight: 10,
            guestCount: 2
        )
        let mockAppartements = Array(0...100).map { id in
            Appartement(
                id: "\(id)",
                hostUserId: "",
                title: "Tiny house",
                city: "Minsk",
                countryCode: "BY",
                pricePerNight: 10,
                guestCount: 2,
                photos: ["image_design_2", "image_design_1", "image_design_3"]
            )
        }
        return AppartementList(
            store: .init(
                initialState: .init(appartements: mockAppartements), reducer: {
                    AppartementListFeature()
                }
            )
        )
    }
#endif
