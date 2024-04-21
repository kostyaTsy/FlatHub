//
//  CreateAppartementFeature.swift
//
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import ComposableArchitecture
import FHRepository
import Foundation

@Reducer
public struct CreateAppartementFeature {
    @ObservableState
    public struct State {
        var isLoading: Bool = false
        var isNextDisabled: Bool = false
        var selection: CreateAppartementFeature.Selection = .chooseType

        var dataModel = AppartementTypesDataModel()
        var appartement = CreateAppartement()

        var chooseType = ChooseAppartementTypeFeature.State()
        var chooseLivingType = ChooseLivingTypeFeature.State()
        var chooseLocation = ChooseLocationFeature.State()
        var chooseGuestsCount = ChooseGuestsCountFeature.State()
        var chooseOffers = ChooseOfferTypesFeature.State()
        var choosePhotos = ChoosePhotosFeature.State()
        var appartementTitle = AppartementTitleFeature.State()
        var appartementDescription = AppartementDescriptionFeature.State()
        var chooseDescriptions = ChooseDescriptionTypesFeature.State()
        var addPrice = AddPriceFeature.State()
        var chooseCancellationPolicy = ChooseCancellationPolicyFeature.State()

        var progress: Double {
            Double(selection.rawValue)
        }

        var total: Double {
            Double(Selection.allCases.count - 1)
        }

        public init() {}
    }

    public enum Action {
        case onAppear
        case onBackTapped
        case onNextTapped
        case onExitTapped
        case onPublishTapped
        case updateLoadingState(Bool)
        case onSelectionChanged(Selection)

        case dataLoaded(AppartementTypesDataModel?)

        case chooseType(ChooseAppartementTypeFeature.Action)
        case chooseLivingType(ChooseLivingTypeFeature.Action)
        case chooseLocation(ChooseLocationFeature.Action)
        case chooseGuestsCount(ChooseGuestsCountFeature.Action)
        case chooseOffers(ChooseOfferTypesFeature.Action)
        case choosePhotos(ChoosePhotosFeature.Action)
        case appartementTitle(AppartementTitleFeature.Action)
        case appartementDescription(AppartementDescriptionFeature.Action)
        case chooseDescriptions(ChooseDescriptionTypesFeature.Action)
        case addPrice(AddPriceFeature.Action)
        case chooseCancellationPolicy(ChooseCancellationPolicyFeature.Action)
    }

    @Dependency(\.appartementTypesRepository) var appartementTypesRepository
    @Dependency(\.geolocationRepository) var geolocationRepository
    @Dependency(\.uploadManager) var uploadManager
    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let dataModel = try? await AppartementTypesDataModel(
                        types: appartementTypesRepository.loadTypes(),
                        offers: appartementTypesRepository.loadOffers(),
                        livings: appartementTypesRepository.loadLivingTypes(),
                        descriptions: appartementTypesRepository.loadDescriptions(),
                        policies: appartementTypesRepository.loadCancellationPolicies()
                    )

                    await send(.dataLoaded(dataModel))
                }
            case .onPublishTapped:
                return .none
            case .onBackTapped:
                let selection = state.selection.prev
                return .send(.onSelectionChanged(selection))
            case .onNextTapped:
                let currentSelection = state.selection
                let state = state
                return .run { send in
                    let shouldShowLoading = currentSelection == .chooseLocation || currentSelection == .choosePhotos
                    await send(.updateLoadingState(shouldShowLoading))
                    let updateSuccessful = await updateAppartementOnNextTapped(
                        state: state,
                        for: currentSelection
                    )

                    guard updateSuccessful else {
                        await send(.updateLoadingState(false))
                        return
                    }
                    let selection = currentSelection.next
                    await send(.onSelectionChanged(selection))
                    await send(.updateLoadingState(false))
                }
            case .onExitTapped:
                return .run { send in
                    await dismiss()
                }
            case .updateLoadingState(let isLoading):
                state.isLoading = isLoading
                return .none
            case .onSelectionChanged(let selection):
                let effect = onChangeSelection(state: &state, selection: selection)
                state.selection = selection
                return effect
            case .dataLoaded(let dataModel):
                state.isLoading = false
                state.dataModel = dataModel ?? AppartementTypesDataModel()
                return .send(.onSelectionChanged(.chooseType))
            case .chooseType(.onDataValidationChanged(let isValid)):
                if state.selection == .chooseType {
                    state.isNextDisabled = !isValid
                }
                return .none
            case .chooseLivingType(.onDataValidationChanged(let isValid)):
                if state.selection == .chooseLivingType {
                    state.isNextDisabled = !isValid
                }
                return .none
            case .chooseOffers(.onDataValidationChanged(let isValid)):
                if state.selection == .chooseOffers {
                    state.isNextDisabled = !isValid
                }
                return .none
            case .choosePhotos(.onPhotosValidationChanged(let isValid)):
                if state.selection == .choosePhotos {
                    state.isNextDisabled = !isValid
                }
                return .none
            case .appartementTitle(.onTitleValidationChanged(let isValid)):
                if state.selection == .appartementTitle {
                    state.isNextDisabled = !isValid
                }
                return .none
            case .appartementDescription(.onDescriptionValidationChanged(let isValid)):
                if state.selection == .appartementDescription {
                    state.isNextDisabled = !isValid
                }
                return .none
            case .chooseDescriptions(.onDataValidationChanged(let isValid)):
                if state.selection == .chooseDescriptions {
                    state.isNextDisabled = !isValid
                }
                return .none
            case .addPrice(.onPriceValidationChanged(let isValid)):
                if state.selection == .addPrice {
                    state.isNextDisabled = !isValid
                }
                return .none
            case .chooseCancellationPolicy(.onDataValidationChanged(let isValid)):
                if state.selection == .chooseCancellationPolicy {
                    state.isNextDisabled = !isValid
                }
                return .none
            case .chooseType, .chooseLivingType, .chooseLocation, .chooseGuestsCount,
                    .chooseOffers, .choosePhotos, .appartementTitle, .appartementDescription,
                    .chooseDescriptions, .addPrice, .chooseCancellationPolicy:
                return .none
            }
        }

        Scope(state: \.chooseType, action: \.chooseType) {
            ChooseAppartementTypeFeature()
        }

        Scope(state: \.chooseLivingType, action: \.chooseLivingType) {
            ChooseLivingTypeFeature()
        }

        Scope(state: \.chooseLocation, action: \.chooseLocation) {
            ChooseLocationFeature()
        }

        Scope(state: \.chooseGuestsCount, action: \.chooseGuestsCount) {
            ChooseGuestsCountFeature()
        }

        Scope(state: \.chooseOffers, action: \.chooseOffers) {
            ChooseOfferTypesFeature()
        }

        Scope(state: \.choosePhotos, action: \.choosePhotos) {
            ChoosePhotosFeature()
        }

        Scope(state: \.appartementTitle, action: \.appartementTitle) {
            AppartementTitleFeature()
        }

        Scope(state: \.appartementDescription, action: \.appartementDescription) {
            AppartementDescriptionFeature()
        }

        Scope(state: \.chooseDescriptions, action: \.chooseDescriptions) {
            ChooseDescriptionTypesFeature()
        }

        Scope(state: \.addPrice, action: \.addPrice) {
            AddPriceFeature()
        }

        Scope(state: \.chooseCancellationPolicy, action: \.chooseCancellationPolicy) {
            ChooseCancellationPolicyFeature()
        }
    }
}

// MARK: - Selection
public extension CreateAppartementFeature {
    enum Selection: Int, CaseIterable {
        case chooseType
        case chooseLivingType
        case chooseLocation
        case chooseGuestsCount
        case chooseOffers
        case choosePhotos
        case appartementTitle
        case appartementDescription
        case chooseDescriptions
        case addPrice
        case chooseCancellationPolicy

        var prev: Self {
            Self(rawValue: self.rawValue - 1) ?? .chooseType
        }

        var next: Self {
            Self(rawValue: self.rawValue + 1) ?? .chooseCancellationPolicy
        }
    }
}

private extension CreateAppartementFeature {
    func onChangeSelection(state: inout State, selection: Selection) -> Effect<Action> {
        switch selection {
        case .chooseType:
            state.isNextDisabled = true
            let appartement = state.appartement
            let items = state.dataModel.types
                .map {
                    let isSelected = $0.id == appartement.type?.id
                    return AppartementTypeMapper.mapToItem(
                        from: $0,
                        isSelected: isSelected
                    )
                }
            return .send(.chooseType(.setData(items)))
        case .chooseLivingType:
            state.isNextDisabled = true
            let appartement = state.appartement
            let items = state.dataModel.livings
                .map {
                    let isSelected = $0.id == appartement.livingType?.id
                    return AppartementTypeMapper.mapToItem(
                        from: $0,
                        isSelected: isSelected
                    )
                }
            return .send(.chooseLivingType(.setData(items)))
        case .chooseLocation:
            let appartement = state.appartement
            guard let latitude = appartement.latitude,
                  let longitude = appartement.longitude
            else {
                return .none
            }
            let model = ChooseLocationModel(
                longitude: longitude,
                latitude: latitude
            )
            return .send(.chooseLocation(.setLocation(model)))
        case .chooseGuestsCount:
            state.isNextDisabled = false
            let appartement = state.appartement
            let model = GuestsCountModel(
                guestsCount: appartement.guestsCount,
                bedroomsCount: appartement.bedroomsCount,
                bedsCount: appartement.bedsCount,
                bathroomsCount: appartement.bathroomsCount
            )
            return .send(.chooseGuestsCount(.setData(model)))
        case .chooseOffers:
            state.isNextDisabled = true
            let appartement = state.appartement
            let items = state.dataModel.offers
                .map { item in
                    let offer = appartement.offers.first(where: { $0.id == item.id })
                    let isSelected = item.id == offer?.id
                    return AppartementTypeMapper.mapToItem(
                        from: item,
                        isSelected: isSelected
                    )
                }
            return .send(.chooseOffers(.setData(items)))
        case .choosePhotos:
            state.isNextDisabled = true
            let photosData = state.appartement.photosData
            return .send(.choosePhotos(.setPhotosData(photosData)))
        case .appartementTitle:
            state.isNextDisabled = true
            let title = state.appartement.title ?? ""
            return .send(.appartementTitle(.setTitle(title)))
        case .appartementDescription:
            state.isNextDisabled = true
            let description = state.appartement.description ?? ""
            return .send(.appartementDescription(.setDescription(description)))
        case .chooseDescriptions:
            state.isNextDisabled = true
            let appartement = state.appartement
            let items = state.dataModel.descriptions
                .map { item in
                    let description = appartement.descriptions.first(where: { $0.id == item.id })
                    let isSelected = item.id == description?.id
                    return AppartementTypeMapper.mapToItem(
                        from: item,
                        isSelected: isSelected
                    )
                }
            return .send(.chooseDescriptions(.setData(items)))
        case .addPrice:
            state.isNextDisabled = true
            let price = state.appartement.price
            return .send(.addPrice(.setPrice(price)))
        case .chooseCancellationPolicy:
            state.isNextDisabled = true
            let appartement = state.appartement
            let items = state.dataModel.policies
                .map {
                    let isSelected = $0.id == appartement.cancellationPolicy?.id
                    return AppartementTypeMapper.mapToItem(
                        from: $0,
                        isSelected: isSelected
                    )
                }
            return .send(.chooseCancellationPolicy(.setData(items)))
        }
    }

    func updateAppartementOnNextTapped(
        state: State,
        for selection: Selection
    ) async -> Bool {
        let appartement = state.appartement
        switch selection {
        case .chooseType:
            let type = state.chooseType.items
                .filter { $0.isSelected }
                .first
                .map { AppartementTypeMapper.mapToType(from: $0) }
            appartement.type = type
            return true
        case .chooseLivingType:
            let livingType = state.chooseLivingType.items
                .filter { $0.isSelected }
                .first
                .map { AppartementTypeMapper.mapToLivingType(from: $0) }
            appartement.livingType = livingType
            return true
        case .chooseLocation:
            let location = state.chooseLocation.location
            guard shouldUpdateGeolocation(
                appartement: appartement,
                latitude: location.latitude,
                longitude: location.longitude
            ) else { return true }

            let route = GeolocationRoute.reverseGeocode(location.latitude, location.longitude)
            let response = try? await geolocationRepository.loadGeocodeReverse(route)
            guard let response,
                  let geolocation = GeolocationMapper.mapToGeolocation(from: response)
            else {
                return false
            }

            appartement.latitude = location.latitude
            appartement.longitude = location.longitude
            appartement.city = geolocation.city
            appartement.country = geolocation.country
            appartement.countryCode = geolocation.countryCode

            return true
        case .chooseGuestsCount:
            let state = state.chooseGuestsCount
            appartement.guestsCount = state.guestsCount
            appartement.bedroomsCount = state.bedroomsCount
            appartement.bedsCount = state.bedsCount
            appartement.bathroomsCount = state.bathroomsCount
            return true
        case .chooseOffers:
            let offers = state.chooseOffers.items
                .filter { $0.isSelected }
                .map { AppartementTypeMapper.mapToOfferType(from: $0) }
            appartement.offers = offers
            return true
        case .choosePhotos:
            let photosData = state.choosePhotos.photosDataModel
            let photosToUpload = photosData.filter { !$0.isUploaded }

            let urls = await withTaskGroup(of: (URL?, PhotoDataModel).self, returning: [URL].self) { group in
                for photo in photosToUpload {
                    let imageDTO = PhotoDataMapper.mapToImageDataDTO(from: photo)
                    group.addTask { (try? await uploadManager.uploadImageData(imageDTO, nil), photo) }
                }

                var urls: [URL] = []
                for await result in group {
                    guard let url = result.0 else { continue }
                    let photo = result.1
                    if let index = photosData.firstIndex(where: { $0.id == photo.id }) {
                        photosData[index].isUploaded = true
                    }
                    urls.append(url)
                }

                return urls
            }
            appartement.photosData = photosData
            appartement.imageUrls = urls
            return true
        case .appartementTitle:
            appartement.title = state.appartementTitle.title
            return true
        case .appartementDescription:
            appartement.description = state.appartementDescription.description
            return true
        case .chooseDescriptions:
            let descriptions = state.chooseDescriptions.items
                .filter { $0.isSelected }
                .map { AppartementTypeMapper.mapToDescriptionType(from: $0) }
            appartement.descriptions = descriptions
            return true
        case .addPrice:
            appartement.price = Int(state.addPrice.price)
            return true
        case .chooseCancellationPolicy:
            let policies = state.dataModel.policies
            let policyItem = state.chooseCancellationPolicy.items
                .filter { $0.isSelected }
                .first
            let policy = policies.first(where: { $0.id == policyItem?.id })
            appartement.cancellationPolicy = policy
            return true
        }
    }

    private func shouldUpdateGeolocation(
        appartement: CreateAppartement,
        latitude: Double,
        longitude: Double
    ) -> Bool {
        appartement.longitude != longitude ||
        appartement.latitude != latitude ||
        appartement.city == nil ||
        appartement.country == nil ||
        appartement.countryCode == nil
    }
}
