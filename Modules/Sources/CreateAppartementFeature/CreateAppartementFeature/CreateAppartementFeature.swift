//
//  CreateAppartementFeature.swift
//
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import ComposableArchitecture
import FHRepository

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
//        var chooseLocation
        var chooseGuestsCount = ChooseGuestsCountFeature.State()
        var chooseOffers = ChooseOfferTypesFeature.State()
//        var choosePhotos
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
        case onSelectionChanged(Selection)

        case dataLoaded(AppartementTypesDataModel?)

        case chooseType(ChooseAppartementTypeFeature.Action)
        case chooseLivingType(ChooseLivingTypeFeature.Action)
//        case chooseLocation
        case chooseGuestsCount(ChooseGuestsCountFeature.Action)
        case chooseOffers(ChooseOfferTypesFeature.Action)
//        case choosePhotos
        case appartementTitle(AppartementTitleFeature.Action)
        case appartementDescription(AppartementDescriptionFeature.Action)
        case chooseDescriptions(ChooseDescriptionTypesFeature.Action)
        case addPrice(AddPriceFeature.Action)
        case chooseCancellationPolicy(ChooseCancellationPolicyFeature.Action)
    }

    @Dependency(\.appartementTypesRepository) var appartementTypesRepository
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
                print("Publish")
                return .none
            case .onBackTapped:
                let selection = state.selection.prev
                return .send(.onSelectionChanged(selection))
            case .onNextTapped:
                let currentSelection = state.selection
                updateAppartementOnNextTapped(state: &state, for: currentSelection)
                let selection = state.selection.next
                return .send(.onSelectionChanged(selection))
            case .onExitTapped:
                return .run { send in
                    await dismiss()
                }
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
//            case .chooseLocation
            case .chooseOffers(.onDataValidationChanged(let isValid)):
                if state.selection == .chooseOffers {
                    state.isNextDisabled = !isValid
                }
                return .none
//            case .choosePhotos
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
            case .chooseType, .chooseLivingType, .chooseGuestsCount,
                    .chooseOffers, .appartementTitle, .appartementDescription,
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

        // Location

        Scope(state: \.chooseGuestsCount, action: \.chooseGuestsCount) {
            ChooseGuestsCountFeature()
        }

        Scope(state: \.chooseOffers, action: \.chooseOffers) {
            ChooseOfferTypesFeature()
        }

        // Photos

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
//        case chooseLocation
        case chooseGuestsCount
        case chooseOffers
//        case choosePhotos
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
//        case .chooseLocation
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
//        case .choosePhotos:
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
        state: inout State,
        for selection: Selection
    ) {
        let appartement = state.appartement
        switch selection {
        case .chooseType:
            let type = state.chooseType.items
                .filter { $0.isSelected }
                .first
                .map { AppartementTypeMapper.mapToType(from: $0) }
            appartement.type = type
        case .chooseLivingType:
            let livingType = state.chooseLivingType.items
                .filter { $0.isSelected }
                .first
                .map { AppartementTypeMapper.mapToLivingType(from: $0) }
            appartement.livingType = livingType
//        case .chooseLocation
        case .chooseGuestsCount:
            let state = state.chooseGuestsCount
            appartement.guestsCount = state.guestsCount
            appartement.bedroomsCount = state.bedroomsCount
            appartement.bedsCount = state.bedsCount
            appartement.bathroomsCount = state.bathroomsCount
        case .chooseOffers:
            let offers = state.chooseOffers.items
                .filter { $0.isSelected }
                .map { AppartementTypeMapper.mapToOfferType(from: $0) }
            appartement.offers = offers
//        case .choosePhotos
        case .appartementTitle:
            appartement.title = state.appartementTitle.title
        case .appartementDescription:
            appartement.description = state.appartementDescription.description
        case .chooseDescriptions:
            let descriptions = state.chooseDescriptions.items
                .filter { $0.isSelected }
                .map { AppartementTypeMapper.mapToDescriptionType(from: $0) }
            appartement.descriptions = descriptions
        case .addPrice:
            appartement.price = Int(state.addPrice.price)
        case .chooseCancellationPolicy:
            let policies = state.dataModel.policies
            let policyItem = state.chooseCancellationPolicy.items
                .filter { $0.isSelected }
                .first
            let policy = policies.first(where: { $0.id == policyItem?.id })
            appartement.cancellationPolicy = policy
        }
    }
}
