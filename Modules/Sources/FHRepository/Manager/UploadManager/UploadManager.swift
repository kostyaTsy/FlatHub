//
//  UploadManager.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation
import FirebaseStorage

public protocol UploadManagerProtocol {
    func uploadImageData(
        _ imageData: ImageDataDTO,
        onProgress: ((TaskProgress) -> Void)?
    ) async throws -> URL

    func getImagesData(_ urls: [URL]) async throws -> [ImageDataResponse]
    func getImageData(_ url: URL) async throws -> ImageDataResponse

    func getImagesURL(_ images: [ImageDataDTO]) async -> [URL]
    func getImageURL(_ imageData: ImageDataDTO) async -> URL?
}

final public class UploadManager: UploadManagerProtocol {
    private let storage: Storage

    public init(storage: Storage = Storage.storage()) {
        self.storage = storage
    }

    public func uploadImageData(
        _ imageData: ImageDataDTO,
        onProgress: ((TaskProgress) -> Void)? = nil
    ) async throws -> URL {
        let path = Constants.imageFolderPath + imageData.name
        let storageRef = storage.reference(withPath: path)

        if let url = await getImageURL(imageData) {
            return url
        }

        let _ = try await storageRef.putDataAsync(imageData.data) { progress in
            guard let progress else { return }
            let taskProgress = TaskProgress(
                completedCount: progress.completedUnitCount,
                totalCount: progress.totalUnitCount,
                fractionCompleted: progress.fractionCompleted
            )
            onProgress?(taskProgress)
        }

        let downloadURL = try await storageRef.downloadURL()
        return downloadURL
    }

    public func getImagesData(_ urls: [URL]) async throws -> [ImageDataResponse] {
        try await withThrowingTaskGroup(of: ImageDataResponse.self) { taskGroup in
            for url in urls {
                taskGroup.addTask { try await self.getImageData(url) }
            }

            var responses: [ImageDataResponse] = []
            for try await response in taskGroup {
                responses.append(response)
            }

            return responses
        }
    }

    public func getImageData(_ url: URL) async throws -> ImageDataResponse {
        let storageRef = try storage.reference(for: url)
        return try await withCheckedThrowingContinuation { continuation in
            storageRef.getData(maxSize: Constants.maxSize) { result in
                switch result {
                case .success(let data):
                    let response = UploadManagerMapper.mapToImageDataResponse(
                        with: url,
                        with: data
                    )
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func getImagesURL(_ images: [ImageDataDTO]) async -> [URL] {
        await withTaskGroup(of: URL?.self) { taskGroup in
            for image in images {
                taskGroup.addTask { await self.getImageURL(image) }
            }

            var urls: [URL] = []
            for await url in taskGroup {
                guard let url else { continue }
                urls.append(url)
            }

            return urls
        }
    }

    public func getImageURL(_ imageData: ImageDataDTO) async -> URL? {
        let path = Constants.imageFolderPath + imageData.name
        let storageRef = storage.reference(withPath: path)

        return try? await storageRef.downloadURL()
    }
}

private extension UploadManager {
    enum Constants {
        static let imageFolderPath = "images/"
        static let maxSize: Int64 = 10_000_000
    }
}
