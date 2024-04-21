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

    public func getImageURL(_ imageData: ImageDataDTO) async -> URL? {
        let path = Constants.imageFolderPath + imageData.name
        let storageRef = storage.reference(withPath: path)

        return try? await storageRef.downloadURL()
    }
}

private extension UploadManager {
    enum Constants {
        static let imageFolderPath = "images/"
    }
}
