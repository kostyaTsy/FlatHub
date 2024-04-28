//
//  AppartementPhotoSlider.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import SwiftUI
import FHCommon
import Kingfisher

struct AppartementPhotoSlider: View {
    private let photos: [String]

    init(photos: [String]) {
        self.photos = photos
    }

    var body: some View {
        GeometryReader { geometry in
            ContentSlider(data: ContentModelBuilder.generateContentModel(from: photos)) { image in
                imageContent(image: image, geometry: geometry)
            }
        }
        .frame(height: Constants.contentHeight)
        .background(Constants.backgroundColor)
        .clipShape(RoundedRectangle(cornerSize: Constants.cornerSize))
    }

    @ViewBuilder private func imageContent(
        image: String,
        geometry: GeometryProxy
    ) -> some View {
        KFImage(URL(string: image))
            .loadDiskFileSynchronously(false)
            .cacheMemoryOnly(false)
            .placeholder({
                AppartementIcons.placeholder
            })
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .clipped()
    }
}

private extension AppartementPhotoSlider {
    enum Constants {
        static let cornerSize = CGSize(width: 20, height: 20)
        static let contentHeight: CGFloat = 300
        static let backgroundColor = Colors.lightGray
    }
}

#if DEBUG
    #Preview {
        AppartementPhotoSlider(
            photos: ["image_design_2", "image_design_1", "image_design_3"]
        )
    }
#endif
