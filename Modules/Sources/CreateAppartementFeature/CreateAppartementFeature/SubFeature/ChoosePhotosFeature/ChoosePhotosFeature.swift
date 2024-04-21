//
//  ChoosePhotosFeature.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import ComposableArchitecture
import PhotosUI
import struct SwiftUI.Image

@Reducer
public struct ChoosePhotosFeature {
    @ObservableState
    public struct State {
        var selectedPhotoItems: [PhotosPickerItem] = []
        var photosDataModel: [PhotoDataModel] = []
        var isLoading: Bool = false

        public init() {}
    }

    public enum Action {
        case onPhotosSelectionChanged([PhotosPickerItem])
        case photosDataLoaded([PhotoDataModel])
        case setPhotosData([PhotoDataModel])
        case updateLoadingState(Bool)
        case deleteImage(PhotoDataModel)
        case onPhotosValidationChanged(Bool)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onPhotosSelectionChanged(let items):
                state.selectedPhotoItems = items
                return .run { send in
                    await send(.updateLoadingState(true))
                    let photosData = await withTaskGroup(of: (Data?, PhotosPickerItem).self, returning: [PhotoDataModel].self) { group in
                        for image in items {
                            group.addTask { (try? await image.loadTransferable(type: Data.self), image) }
                        }

                        var photosData: [PhotoDataModel] = []
                        for await result in group {
                            guard let data = result.0 else { continue }
                            let item = result.1
                            let type = item.supportedContentTypes.first
                            let photoData = PhotoDataModel(
                                id: item.itemIdentifier ?? UUID().uuidString,
                                data: data,
                                mimeType: type?.preferredMIMEType,
                                fileExtension: type?.preferredFilenameExtension
                            )
                            photosData.append(photoData)
                        }

                        return photosData
                    }
                    await send(.photosDataLoaded(photosData))
                }
            case .setPhotosData(let data):
                // TODO: check this
                state.selectedPhotoItems = data.map { PhotosPickerItem(itemIdentifier: $0.id) }
                return .send(.photosDataLoaded(data))
            case .photosDataLoaded(let data):
                state.isLoading = false
                state.photosDataModel = data
                let isValidData = !data.isEmpty
                return .send(.onPhotosValidationChanged(isValidData))
            case .updateLoadingState(let isLoading):
                state.isLoading = isLoading
                return .none
            case .deleteImage(let model):
                print("delete")
                if let index = state.selectedPhotoItems.firstIndex(where: { $0.itemIdentifier == model.id }) {
                    state.selectedPhotoItems.remove(at: index)
                }
                if let index = state.photosDataModel.firstIndex(where: { $0.id == model.id }) {
                    state.photosDataModel.remove(at: index)
                }
                let isValidData = !state.photosDataModel.isEmpty
                return .send(.onPhotosValidationChanged(isValidData))
            case .onPhotosValidationChanged:
                return .none
            }
        }
    }
}
