//
//  ChoosePhotosView.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import ComposableArchitecture
import SwiftUI
import PhotosUI
import FHCommon

struct ChoosePhotosView: View {
    @Perception.Bindable private var store: StoreOf<ChoosePhotosFeature>

    private let photoColumns = [
        GridItem(.flexible(), spacing: Layout.Spacing.smallMedium),
        GridItem(.flexible(), spacing: Layout.Spacing.smallMedium)
    ]

    init(store: StoreOf<ChoosePhotosFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(title: Strings.choosePhotosTitle) {
            conditionalContent()
        }
        .padding(.top, Layout.Spacing.medium)
    }

    @ViewBuilder private func conditionalContent() -> some View {
        if store.isLoading {
            VStack {
                Spacer()
                ProgressView(Strings.loadingText)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        } else if store.photosDataModel.isEmpty {
            noSelectedPhotosView()
        } else {
            selectedPhotosView()
        }
    }

    @ViewBuilder private func noSelectedPhotosView() -> some View {
        VStack {
            Spacer()
            selectPhotosView()
            Spacer()
        }
    }

    @ViewBuilder private func selectPhotosView() -> some View {
        PhotosPicker(
            selection: $store.selectedPhotoItems.sending(\.onPhotosSelectionChanged)
        ) {
            Text(Strings.choosePhotosButtonTitle)
                .padding([.top, .bottom])
                .frame(maxWidth: .infinity)
                .foregroundColor(Constants.photosButtonForegroundColor)
                .background(Constants.photosButtonBackgroundColor)
                .cornerRadius(Constants.photosButtonCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.photosButtonCornerRadius)
                        .stroke(
                            Constants.photosButtonBorderColor,
                            lineWidth: Constants.photosButtonBorderWidth
                        )
                )
        }
    }

    @ViewBuilder private func selectedPhotosView() -> some View {
        selectPhotosView()
            .padding(.bottom, Layout.Spacing.medium)
        // TODO: think about better UI
        ScrollView {
            LazyVGrid(
                columns: photoColumns,
                spacing: Layout.Spacing.smallMedium
            ) {
                ForEach(store.photosDataModel) { item in
                    photoCell(item: item)
                }
            }
        }
    }

    @ViewBuilder private func photoCell(item: PhotoDataModel) -> some View {
        if let uiImage = UIImage(data: item.data) {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: Constants.photoCellMaxHeight)
                    .clipped()

                Button {
                    store.send(.deleteImage(item))
                } label: {
                    Icons.closeIcon
                        .foregroundStyle(.white)
                }
                .background {
                    Rectangle()
                        .blur(radius: Constants.deleteItemIconBlurRadius)
                }
                .padding([.top, .trailing], Layout.Spacing.small)
            }
        }
    }
}

private extension ChoosePhotosView {
    enum Constants {
        static let photosButtonForegroundColor = Colors.label
        static let photosButtonBackgroundColor = Colors.system
        static let photosButtonBorderColor = Colors.lightGray
        static let photosButtonBorderWidth: CGFloat = 1
        static let photosButtonCornerRadius: CGFloat = 20
        static let photoCellMaxHeight: CGFloat = 150
        static let deleteItemIconBlurRadius: CGFloat = 10
    }
}

#if DEBUG
    #Preview {
        ChoosePhotosView(
            store: .init(
                initialState: .init(), reducer: {
                    ChoosePhotosFeature()
                }
            )
        )
    }
#endif
