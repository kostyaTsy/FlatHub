//
//  ListingCell.swift
//
//
//  Created by Kostya Tsyvilko on 22.04.24.
//

import SwiftUI
import Kingfisher
import FHCommon

struct ListingCell: View {
    private let appartement: HostAppartement

    init(appartement: HostAppartement) {
        self.appartement = appartement
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            content()

            availabilityView()
                .padding([.top, .leading], Layout.Spacing.small)
        }
    }

    @ViewBuilder private func content() -> some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.small) {
            GeometryReader { geometry in
                let processor = DownsamplingImageProcessor(size: geometry.size)
                KFImage(appartement.firstPhotoURL)
                    .loadDiskFileSynchronously(false)
                    .cacheMemoryOnly(false)
                    .setProcessor(processor)
                    .placeholder({
                        AppartementIcons.placeholder
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: Constants.photoCornerRadius
                        )
                    )
                    .clipped()
            }
            .frame(height: Constants.photoHeight)

            Text(appartement.title)
                .font(Constants.titleFont)

            Text(appartement.location)
                .font(Constants.locationFont)
                .foregroundStyle(Constants.locationTextColor)
        }
    }

    @ViewBuilder private func availabilityView() -> some View {
        HStack {
            Circle()
                .frame(width: Constants.indicatorSize, height: Constants.indicatorSize)
                .foregroundStyle(
                    appartement.isAvailableForBook ? Constants.availableColor : Constants.notAvailableColor
                )
            Text(appartement.isAvailableForBook ? Strings.availableAppartementText : Strings.notAvailableAppartementText)

            Spacer()
        }
        .frame(width: Constants.availabilityViewWidth)
        .padding(.horizontal)
        .padding(.vertical, Layout.Spacing.small)
        .background {
            RoundedRectangle(
                cornerRadius: Constants.availabilityViewCornerRadius
            )
            .foregroundStyle(Colors.system)
        }
    }
}

private extension ListingCell {
    enum Constants {
        static let availabilityViewCornerRadius: CGFloat = 20
        static let availabilityViewWidth: CGFloat = 100
        static let availableColor: Color = .green
        static let notAvailableColor: Color = .red
        static let indicatorSize: CGFloat = 10

        static let titleFont: Font = .system(size: 16, weight: .medium)
        static let locationFont: Font = .system(size: 14)
        static let locationTextColor: Color = .secondary

        static let photoHeight: CGFloat = 300
        static let photoCornerRadius: CGFloat = 20
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
        return ListingCell(appartement: mockAppartement)
    }
#endif
