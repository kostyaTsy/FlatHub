//
//  AppartementDetailsPhotoSlider.swift
//
//
//  Created by Kostya Tsyvilko on 4.05.24.
//

import SwiftUI
import FHCommon
import Kingfisher

struct AppartementDetailsPhotoSlider: View {
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
    }

    @ViewBuilder private func imageContent(
        image: String,
        geometry: GeometryProxy
    ) -> some View {
        let processor = DownsamplingImageProcessor(size: geometry.size)
        KFImage(URL(string: image))
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
            .clipped()
    }
}

private extension AppartementDetailsPhotoSlider {
    enum Constants {
        static let cornerSize = CGSize(width: 20, height: 20)
        static let contentHeight: CGFloat = 350
        static let backgroundColor = Colors.lightGray
    }
}

#if DEBUG
    #Preview {
        AppartementDetailsPhotoSlider(
            photos: []
        )
    }
#endif
