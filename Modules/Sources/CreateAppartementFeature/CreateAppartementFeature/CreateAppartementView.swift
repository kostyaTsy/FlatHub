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
                    .foregroundStyle(.black)
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

            // TODO: add location

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

            Text("Last")
                .tag(CreateAppartementFeature.Selection.last)
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
                Button {
                    store.send(.onBackTapped)
                } label: {
                    Text(Strings.navigationBackButtonTitle)
                        .underline()
                }
                .foregroundStyle(.black)

                Spacer()
                FHOvalButton(
                    title: Strings.navigationNextButtonTitle,
                    disabled: store.isNextDisabled,
                    configuration: Constants.nextButtonConfiguration
                ) {
                    store.send(.onNextTapped)
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
            foregroundColor: .black,
            borderColor: .gray,
            borderWidth: 1)
        static let exitButtonWidth: CGFloat = 100
        static let nextButtonConfiguration = FHOvalButton.Configuration(
            backgroundColor: .black,
            foregroundColor: .white
        )
        static let nextButtonWidth: CGFloat = 100
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
