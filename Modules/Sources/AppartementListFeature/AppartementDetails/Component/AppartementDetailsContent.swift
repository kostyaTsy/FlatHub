//
//  AppartementDetailsContent.swift
//
//
//  Created by Kostya Tsyvilko on 4.05.24.
//

import SwiftUI
import MapKit
import FHRepository
import FHCommon

struct AppartementDetailsContent: View {
    private let model: AppartementModel
    private let info: AppartementInfoModel?

    init(
        appartementModel: AppartementModel,
        appartementInfoModel: AppartementInfoModel?
    ) {
        self.model = appartementModel
        self.info = appartementInfoModel
    }

    var body: some View {
        content()
            .padding(.horizontal, Layout.Spacing.smallMedium)

    }

    @ViewBuilder private func content() -> some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(Constants.titleFont)
                .padding(.bottom, Layout.Spacing.small)
            Text(model.location)
                .fontWeight(.medium)
                .padding(.bottom, 1)
            Text(
                String(
                    format: Strings.roomsCountString,
                    model.guestCount, info?.bedrooms ?? 0,
                    info?.beds ?? 0, info?.bathrooms ?? 0
                )
            )
            .font(Constants.roomsCountFont)

            if model.rating != nil {
                HStack(spacing: Constants.ratingSpacing) {
                    Icons.starFillIcon
                        .imageScale(.small)
                    Text(model.formattedRating)
                }
                .padding(.top, Layout.Spacing.xSmall)
            }

            customDivider()
            Text(info?.description ?? "")
            customDivider()

            if let info {
                // Housing
                housingSection(info: info)

                // Offers
                offersSection(info: info)

                // Descriptions
                housingDescriptionsSection(info: info)

                // Location
                locationSection(info: info)

                // Cancellation Policy
                cancellationPolicySection(info: info)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func customDivider() -> some View {
        Divider()
            .padding(.vertical, Layout.Spacing.small)
    }

    @ViewBuilder private func customSection(
        title: String,
        withTopDivider: Bool = false,
        withBottomDivider: Bool = false,
        @ViewBuilder content: () -> some View
    ) -> some View {
        if withTopDivider {
            customDivider()
        }

        Text(title)
            .font(Constants.titleFont)
            .padding(.bottom, Layout.Spacing.small)

        content()

        if withBottomDivider {
            customDivider()
        }
    }

    // MARK: - Housing

    @ViewBuilder private func housingSection(
        info: AppartementInfoModel
    ) -> some View {
        customSection(
            title: Strings.livingsSectionTitle,
            withBottomDivider: true
        ) {
            VStack(alignment: .leading) {
                HStack(spacing: Layout.Spacing.smallMedium) {
                    Image(systemName: info.type.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Constants.iconCellSize)
                    Text(info.type.name)
                }
                .padding(.bottom, Layout.Spacing.smallMedium)

                Text(info.livingType.description)
                    .foregroundStyle(Colors.lightGray)
            }
        }
    }

    // MARK: - Offer

    @ViewBuilder private func offersSection(
        info: AppartementInfoModel
    ) -> some View {
        customSection(
            title: Strings.offerSectionTitle,
            withBottomDivider: true
        ) {
            ForEach(info.offers) { offer in
                HStack(spacing: Layout.Spacing.smallMedium) {
                    Image(systemName: offer.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Constants.iconCellSize)
                    Text(offer.name)
                }
            }
        }
    }

    // MARK: Descriptions

    @ViewBuilder private func housingDescriptionsSection(
        info: AppartementInfoModel
    ) -> some View {
        customSection(
            title: Strings.housingDescriptionsSection,
            withBottomDivider: true
        ) {
            ForEach(info.descriptionTypes) { description in
                HStack(spacing: Layout.Spacing.smallMedium) {
                    Image(systemName: description.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Constants.iconCellSize)
                    Text(description.name)
                }
            }
        }
    }

    // MARK: - Location

    @ViewBuilder private func locationSection(
        info: AppartementInfoModel
    ) -> some View {
        customSection(
            title: Strings.locationSectionTitle,
            withBottomDivider: true
        ) {
            Map(
                coordinateRegion: .constant(
                    MKCoordinateRegion(
                        center: .init(latitude: info.latitude, longitude: info.longitude),
                        span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    )
                ),
                annotationItems: [info]
            ) { info in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
                ) {
                    Circle()
                        .frame(
                            width: Constants.mapAnnotationSize,
                            height: Constants.mapAnnotationSize
                        )
                        .foregroundStyle(.red)
                }
            }
            .frame(height: Constants.mapHeight)
        }
    }

    // MARK: - Cancellation Policy

    @ViewBuilder private func cancellationPolicySection(
        info: AppartementInfoModel
    ) -> some View {
        customSection(title: Strings.cancellationPolicySectionTitle) {
            Text(info.cancellationPolicy.travelDescription)
        }
    }
}

private extension AppartementDetailsContent {
    enum Constants {
        static let roomsCountFont = Font.system(size: 14)
        static let titleFont = Font.system(size: 24, weight: .medium)
        static let mapHeight: CGFloat = 300
        static let iconCellSize: CGFloat = 20
        static let mapAnnotationSize: CGFloat = 20
        static let ratingSpacing: CGFloat = 3
    }
}

#if DEBUG
    #Preview {
        let mockAppartementModel = AppartementModel(
            id: "123",
            hostUserId: "123",
            title: "Title",
            city: "Minsk",
            countryCode: "Country code",
            pricePerNight: 20,
            guestCount: 4
        )

        let mockAppartementInfoModel = AppartementInfoModel(
            latitude: 53.893009,
            longitude: 27.567444,
            description: "Some cool description",
            bedrooms: 2,
            beds: 1,
            bathrooms: 1,
            type: .init(id: 1, name: "type", iconName: "person"),
            livingType: .init(id: 1, title: "tile", description: "desc", iconName: "person"),
            offers: [
                .init(id: 1, name: "test", iconName: "person")
            ],
            descriptionTypes: [],
            cancellationPolicy: .init(id: 1, title: "title", hostDescription: "hostDesc", travelDescription: "travelDesc")
        )

        return ScrollView {
             AppartementDetailsContent(
                appartementModel: mockAppartementModel,
                appartementInfoModel: mockAppartementInfoModel
            )
        }
    }
#endif
