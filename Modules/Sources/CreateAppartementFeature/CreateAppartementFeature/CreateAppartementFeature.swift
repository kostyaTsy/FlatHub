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

        var chooseType = ChooseAppartementTypeFeature.State()

        var progress: Double {
            Double(selection.rawValue)
        }

        var total: Double {
            Double(Selection.allCases.count)
        }

        public init() {}
    }

    public enum Action {
        case onAppear
        case onBackTapped
        case onNextTapped
        case onSelectionChanged(Selection)

        case dataLoaded(AppartementTypesDataModel?)

        case chooseType(ChooseAppartementTypeFeature.Action)
    }

    @Dependency(\.appartementTypesRepository) var appartementTypesRepository

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
            case .onBackTapped:
                let selection = state.selection.prev
                return .send(.onSelectionChanged(selection))
            case .onNextTapped:
                let selection = state.selection.next
                return .send(.onSelectionChanged(selection))
            case .onSelectionChanged(let selection):
                print(state.dataModel.types)
                switch selection {
                case .chooseType:
                    state.chooseType.types = state.dataModel.types
                default: ()
                }
                state.selection = selection
                return .none
            case .dataLoaded(let dataModel):
                state.isLoading = false
                state.dataModel = dataModel ?? AppartementTypesDataModel()
                return .none

            case .chooseType:
                return .none
            }
        }
    }
}

// MARK: - Selection
public extension CreateAppartementFeature {
    enum Selection: Int, CaseIterable {
        case chooseType

        case last

        var prev: Self {
            Self(rawValue: self.rawValue - 1) ?? .chooseType
        }

        var next: Self {
            Self(rawValue: self.rawValue + 1) ?? .last
        }
    }
}
