//
//  AppartementCell.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import SwiftUI
import FHCommon
import FHRepository

struct AppartementCell: View {
    private let appartement: AppartementModel
    private let favouriteButtonTapped: (() -> Void)?

    init(appartement: AppartementModel, favouriteButtonTapped: (() -> Void)? = nil) {
        self.appartement = appartement
        self.favouriteButtonTapped = favouriteButtonTapped
    }

    var body: some View {
        LazyVStack {
            ZStack(alignment: .topTrailing) {
                AppartementPhotoSlider(photos: appartement.photos)
                    .padding(.bottom, Layout.Spacing.small)

                favouriteIcon()
            }

            descriptionView()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Colors.system)
    }

    @ViewBuilder private func favouriteIcon() -> some View {
        Button {
            favouriteButtonTapped?()
        } label: {
            Image(systemName: appartement.isFavourite ?
                  Icons.favouriteFillIconName : Icons.favouriteIconName)
                .resizable()
                .frame(width: Constants.favouriteIconSize, height: Constants.favouriteIconSize)
                .foregroundStyle(appartement.isFavourite ? .pink : .white)
        }
        .background {
            Rectangle()
                .blur(radius: Constants.favouriteIconBlurRadius)
        }
        .padding([.top, .trailing], Layout.Spacing.smallMedium)
    }

    @ViewBuilder private func descriptionView() -> some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.xSmall) {
            descriptionTopPartView()

            Text(appartement.title)
                .font(.system(size: Constants.titleFontSize))
                .foregroundStyle(Constants.titleTextColor)

            HStack(spacing: .zero) {
                Text("\(Strings.currencySign)\(appartement.pricePerNight)")
                    .fontWeight(.medium)

                Text(Strings.nightText)
                    .padding(.leading, Constants.nightLeadingSpacing)
            }
            .padding(.top, Layout.Spacing.xSmall)
            .font(.system(size: Constants.priceFontSize))
        }
    }

    @ViewBuilder private func descriptionTopPartView() -> some View {
        HStack {
            Text(appartement.location)
                .fontWeight(.medium)
                .font(.system(size: Constants.locationFontSize))

            Spacer()

            if appartement.rating != nil {
                HStack(spacing: Constants.ratingSpacing) {
                    Icons.starFillIcon
                        .imageScale(.small)
                    Text(appartement.formattedRating)
                }
            }
        }
    }
}

private extension AppartementCell {
    enum Constants {
        static let locationFontSize: CGFloat = 16
        static let titleFontSize: CGFloat = 16
        static let titleTextColor: Color = .secondary
        static let priceFontSize: CGFloat = 16
        static let nightLeadingSpacing: CGFloat = 3
        static let favouriteIconSize: CGFloat = 25
        static let favouriteIconBlurRadius: CGFloat = 15
        static let ratingSpacing: CGFloat = 3
    }
}

#if DEBUG
#Preview {
    let mockAppartement = AppartementModel(
        id: "",
        hostUserId: "",
        title: "Tiny house",
        city: "Minsk",
        countryCode: "BY",
        pricePerNight: 10,
        guestCount: 2,
        isFavourite: false,
        photos: ["image_design_2", "image_design_1", "image_design_3"]
    )
    return AppartementCell(appartement: mockAppartement)
}
#endif
