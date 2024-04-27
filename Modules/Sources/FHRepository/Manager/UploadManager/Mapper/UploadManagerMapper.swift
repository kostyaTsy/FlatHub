//
//  UploadManagerMapper.swift
//
//
//  Created by Kostya Tsyvilko on 27.04.24.
//

import Foundation

enum UploadManagerMapper {
    static func mapToImageDataResponse(
        with url: URL,
        with data: Data
    ) -> ImageDataResponse {
        ImageDataResponse(
            url: url,
            data: data
        )
    }
}
