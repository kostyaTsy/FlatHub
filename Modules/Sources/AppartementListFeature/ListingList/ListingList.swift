//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 22.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

public struct ListingList: View {
    @Perception.Bindable private var store: StoreOf<ListingListFeature>

    public init(store: StoreOf<ListingListFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            if !store.isDataLoaded {
                ProgressView(Strings.loadingText)
            } else if store.isDataLoaded && store.appartements.isEmpty {
                Text(Strings.noDataText)
            } else {
                content()
                    .padding(.horizontal, Layout.Spacing.smallMedium)
            }
        }
    }

    @ViewBuilder private func content() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(store.appartements) { appartement in
                    ListingCell(appartement: appartement)
                        .padding(.bottom, Layout.Spacing.big50)
                        .onTapGesture {
                            store.send(.onAppartementTapped(appartement))
                        }
                }
            }
        }
    }
}

#if DEBUG
    #Preview {
        let mockAppartement = HostAppartement(
            id: "id",
            hostUserId: "",
            title: "title",
            city: "city",
            country: "county",
            countryCode: "countyCode",
            isAvailableForBook: true,
            pricePerNight: 12,
            guestCount: 3,
            photosStringURL: [],
            details: .init(
                appartementId: "id",
                latitude: 12,
                longitude: 12,
                description: "description",
                bedrooms: 1,
                beds: 1,
                bathrooms: 1,
                type: .init(id: 1, name: "name", iconName: "person"),
                livingType: .init(id: 1, title: "title", description: "description", iconName: "person"),
                offers: [],
                descriptionTypes: [],
                cancellationPolicy: .init(id: 1, title: "", hostDescription: "", travelDescription: "")
            )
        )
        return ListingList(
            store: .init(
                initialState: .init(appartements: [mockAppartement]), reducer: {
                    ListingListFeature()
                }
            )
        )
    }
#endif
