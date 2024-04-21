//
//  PhotoDataMapper.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation
import FHRepository

enum PhotoDataMapper {
    static func mapToImageDataDTO(
        from: PhotoDataModel
    ) -> ImageDataDTO {
        ImageDataDTO(
            id: from.id,
            data: from.data,
            mimeType: from.mimeType,
            fileExtension: from.fileExtension
        )
    }
}
