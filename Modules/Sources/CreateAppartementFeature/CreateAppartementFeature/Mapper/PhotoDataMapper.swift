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

    static func mapToPhotoDataModel(
        from response: ImageDataResponse
    ) -> PhotoDataModel {
        let fileName = response.url.getFileNameWithoutExtension()
        let fileExtension = response.url.getFileExtension()
        return PhotoDataModel(
            id: fileName ?? UUID().uuidString,
            data: response.data,
            fileExtension: fileExtension,
            isSaved: true
        )
    }
}
