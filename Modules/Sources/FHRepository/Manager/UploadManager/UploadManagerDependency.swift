//
//  UploadManagerDependency.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation
import Dependencies

public struct UploadManagerDependency: Sendable {
    public var uploadImageData: @Sendable (
        _ imageData: ImageDataDTO,
        _ onProgress: ((TaskProgress) -> Void)? 
    ) async throws -> URL

    public var getImagesData: @Sendable (_ urls: [URL]) async throws -> [ImageDataResponse]
    public var getImageData: @Sendable (_ url: URL) async throws -> ImageDataResponse
}

// MARK: - Live

extension UploadManagerDependency {
    static func live(uploadManager: UploadManagerProtocol = UploadManager()) -> UploadManagerDependency {
        let dependency = UploadManagerDependency(
            uploadImageData: { imageDTO, onProgress in
                try await uploadManager.uploadImageData(imageDTO, onProgress: onProgress)
            }, getImagesData: { urls in
                try await uploadManager.getImagesData(urls)
            }, getImageData: { url in
                try await uploadManager.getImageData(url)
            }
        )

        return dependency
    }
}

// MARK: - Mock

extension UploadManagerDependency {
    static func mock() -> UploadManagerDependency {
        let dependency = UploadManagerDependency(
            uploadImageData: { imageDTO, onProgress in
                URL(string: "https://www.google.com/")!
            }, getImagesData: { _ in
                []
            }, getImageData: { _ in
                ImageDataResponse(
                    url: URL(string: "https://www.google.com/")!,
                    data: Data()
                )
            }
        )

        return dependency
    }
}

// MARK: - Dependency

extension UploadManagerDependency: DependencyKey {
    public static var liveValue: UploadManagerDependency {
        UploadManagerDependency.live()
    }

    public static var previewValue: UploadManagerDependency {
        UploadManagerDependency.mock()
    }

    public static var testValue: UploadManagerDependency {
        UploadManagerDependency.mock()
    }
}

extension DependencyValues {
    public var uploadManager: UploadManagerDependency {
        get { self[UploadManagerDependency.self] }
        set { self[UploadManagerDependency.self] = newValue }
    }
}
