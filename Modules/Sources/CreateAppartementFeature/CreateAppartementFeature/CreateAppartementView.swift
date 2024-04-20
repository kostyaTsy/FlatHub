//
//  CreateAppartementView.swift
//
//
//  Created by Kostya Tsyvilko on 16.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

public struct CreateAppartementView: View {
    @Perception.Bindable private var store: StoreOf<CreateAppartementFeature>

    public init(store: StoreOf<CreateAppartementFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                if store.isLoading {
                    ProgressView(Strings.loadingText)
                } else {
                    contentView()
                    footerView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        store.send(.onExitTapped)
                    } label: {
                        Text(Strings.navigationExitButtonTitle)
                            .underline()
                    }
                    .foregroundStyle(Colors.label)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder private func contentView() -> some View {
        TabView(selection: $store.selection.sending(\.onSelectionChanged)) {
            ChooseAppartementTypeView(
                store: store.scope(state: \.chooseType, action: \.chooseType)
            )
            .tag(CreateAppartementFeature.Selection.chooseType)

            ChooseLivingTypeView(
                store: store.scope(state: \.chooseLivingType, action: \.chooseLivingType)
            )
            .tag(CreateAppartementFeature.Selection.chooseLivingType)

            ChooseLocationView(
                store: store.scope(state: \.chooseLocation, action: \.chooseLocation)
            )
            .tag(CreateAppartementFeature.Selection.chooseLocation)

            ChooseGuestsCountView(
                store: store.scope(state: \.chooseGuestsCount, action: \.chooseGuestsCount)
            )
            .tag(CreateAppartementFeature.Selection.chooseGuestsCount)

            ChooseOfferTypesView(
                store: store.scope(state: \.chooseOffers, action: \.chooseOffers)
            )
            .tag(CreateAppartementFeature.Selection.chooseOffers)

            // TODO: add upload photos

            AppartementTitleView(
                store: store.scope(state: \.appartementTitle, action: \.appartementTitle)
            )
            .tag(CreateAppartementFeature.Selection.appartementTitle)

            AppartementDescriptionView(
                store: store.scope(state: \.appartementDescription, action: \.appartementDescription)
            )
            .tag(CreateAppartementFeature.Selection.appartementDescription)

            ChooseDescriptionTypesView(
                store: store.scope(state: \.chooseDescriptions, action: \.chooseDescriptions)
            )
            .tag(CreateAppartementFeature.Selection.chooseDescriptions)

            AddPriceView(
                store: store.scope(state: \.addPrice, action: \.addPrice)
            )
            .tag(CreateAppartementFeature.Selection.addPrice)

            ChooseCancellationPolicyView(
                store: store.scope(state: \.chooseCancellationPolicy, action: \.chooseCancellationPolicy)
            )
            .tag(CreateAppartementFeature.Selection.chooseCancellationPolicy)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = false
        }
    }

    @ViewBuilder private func footerView() -> some View {
        VStack(spacing: .zero) {
            ProgressView(
                value: store.progress,
                total: store.total
            )
            HStack {
                if store.progress != .zero {
                    Button {
                        hideKeyboard()
                        store.send(.onBackTapped)
                    } label: {
                        Text(Strings.navigationBackButtonTitle)
                            .underline()
                    }
                    .foregroundStyle(Colors.label)
                }

                Spacer()
                FHOvalButton(
                    title: store.progress == store.total ? Strings.navigationPublishButtonTitle : Strings.navigationNextButtonTitle,
                    disabled: store.isNextDisabled,
                    configuration: Constants.nextButtonConfiguration
                ) {
                    hideKeyboard()
                    if store.progress == store.total {
                        store.send(.onPublishTapped)
                    } else {
                        store.send(.onNextTapped)
                    }
                }
                .frame(width: Constants.nextButtonWidth)
            }
            .padding(.horizontal)
        }
    }
}

private extension CreateAppartementView {
    enum Constants {
        static let exitButtonConfiguration = FHOvalButton.Configuration(
            backgroundColor: Colors.system,
            foregroundColor: Colors.label,
            borderColor: .gray,
            borderWidth: 1)
        static let exitButtonWidth: CGFloat = 100
        static let nextButtonConfiguration = FHOvalButton.Configuration(
            backgroundColor: Colors.label,
            foregroundColor: Colors.system
        )
        static let nextButtonWidth: CGFloat = 100
        static let backButtonDisabledOpacity: CGFloat = 0.6
        static let backButtonEnabledOpacity: CGFloat = 1.0
    }
}

#if DEBUG
    #Preview {
        NavigationView {
            CreateAppartementView(
                store: .init(
                    initialState: .init(), reducer: {
                        CreateAppartementFeature()
                    }, withDependencies: {
                        $0.appartementTypesRepository = .previewValue
                    }
                )
            )
        }
    }
#endif
