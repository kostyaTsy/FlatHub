//
//  SearchView.swift
//
//
//  Created by Kostya Tsyvilko on 27.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct SearchView: View {
    @Perception.Bindable private var store: StoreOf<SearchFeature>

    @State var collapsed: Bool = true

    public init(store: StoreOf<SearchFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
                .onAppear {
                    store.send(.onAppear)
                }
        }
    }

    @ViewBuilder private func content() -> some View {
        VStack {
            headerView()
                .padding(.bottom)

            chooseContainers()

            footerView()
        }
    }

    @ViewBuilder private func headerView() -> some View {
        HStack {
            Button {
                store.send(.closeIconTapped)
            } label: {
                Icons.closeIcon
                    .font(.title)
                    .foregroundStyle(Colors.lightGray)
            }

            Spacer()
        }
    }

    @ViewBuilder private func chooseContainers() -> some View {
        ScrollView {
            VStack(spacing: Layout.Spacing.medium) {
                ChooseCityView(
                    store: store.scope(state: \.chooseCity, action: \.chooseCity)
                )

                ChooseTripDateView(
                    store: store.scope(state: \.chooseDates, action: \.chooseDates)
                )

                ChooseTravellersView(
                    store: store.scope(state: \.chooseGuests, action: \.chooseGuests)
                )
            }
        }
        .scrollIndicators(.never)
    }

    @ViewBuilder private func footerView() -> some View {
        HStack {
            FHOvalButton(
                title: Strings.searchResetButtonTitle,
                configuration: Constants.applyButtonConfiguration
            ) {
                hideKeyboard()
                store.send(.onResetTapped)
            }
            .frame(width: Constants.applyButtonWidth)
            Spacer()
            FHOvalButton(
                title: Strings.searchApplyButtonTitle,
                configuration: Constants.applyButtonConfiguration
            ) {
                hideKeyboard()
                store.send(.onApplyTapped)
            }
            .frame(width: Constants.applyButtonWidth)
        }
        .padding(.horizontal)
    }
}

private extension SearchView {
    enum Constants {
        static let applyButtonConfiguration = FHOvalButton.Configuration(
            backgroundColor: Colors.label,
            foregroundColor: Colors.system
        )
        static let applyButtonWidth: CGFloat = 100
    }
}

#if DEBUG
    #Preview {
        SearchView(
            store: .init(
                initialState: .init(), reducer: {
                    SearchFeature()
                }
            )
        )
    }
#endif
