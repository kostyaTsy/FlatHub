//
//  PhotoDataModel.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

final public class PhotoDataModel: Identifiable {
    public let id: String
    let data: Data
    let mimeType: String?
    let fileExtension: String?
    var isUploaded: Bool

    init(
        id: String = UUID().uuidString,
        data: Data,
        mimeType: String? = nil,
        fileExtension: String? = nil,
        isSaved: Bool = false
    ) {
        self.id = id
        self.data = data
        self.mimeType = mimeType
        self.fileExtension = fileExtension
        self.isUploaded = isSaved
    }
}

