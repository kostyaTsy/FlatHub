//
//  ImageDataDTO.swift
//  
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

public struct ImageDataDTO {
    let id: String
    let data: Data
    let mimeType: String?
    let fileExtension: String?

    var name: String {
        guard let fileExtension else {
            return id
        }
        return "\(id).\(fileExtension)"
    }

    public init(
        id: String,
        data: Data,
        mimeType: String?,
        fileExtension: String?
    ) {
        self.id = id
        self.data = data
        self.mimeType = mimeType
        self.fileExtension = fileExtension
    }
}
