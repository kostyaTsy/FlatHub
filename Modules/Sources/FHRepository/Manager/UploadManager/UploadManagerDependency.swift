//
//  UploadManagerDependency.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation
import Dependencies

public struct UploadManagerDependency {
    public var uploadImageData: @Sendable (
        _ imageData: ImageDataDTO,
        _ onProgress: ((TaskProgress) -> Void)? 
    ) async throws -> URL
}

// MARK: - Live

extension UploadManagerDependency {
    static func live(uploadManager: UploadManagerProtocol = UploadManager()) -> UploadManagerDependency {
        let dependency = UploadManagerDependency(
            uploadImageData: { imageDTO, onProgress in
                try await uploadManager.uploadImageData(imageDTO, onProgress: onProgress)
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
