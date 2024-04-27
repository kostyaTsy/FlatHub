//
//  ImageDataResponse.swift
//  
//
//  Created by Kostya Tsyvilko on 27.04.24.
//

import Foundation

public struct ImageDataResponse {
    public var url: URL
    public var data: Data

    public init(
        url: URL,
        data: Data
    ) {
        self.url = url
        self.data = data
    }
}
