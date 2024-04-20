//
//  ChooseLocationView.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import SwiftUI
import MapKit
import FHCommon

struct ChooseLocationView: View {
    @Perception.Bindable private var store: StoreOf<ChooseLocationFeature>

    init(store: StoreOf<ChooseLocationFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(
            title: Strings.chooseLocationTitle,
            subtitle: Strings.chooseLocationSubtitle,
            configuration: .init(
                horizontalPadding: Layout.Spacing.smallMedium
            )
        ) {
            mapContent()
        }
        .padding(.top, Layout.Spacing.medium)
    }

    @ViewBuilder private func mapContent() -> some View {
        ZStack(alignment: .center) {
            Map(
                coordinateRegion: $store.locationRegion.sending(\.onMapLocationChanged),
                showsUserLocation: true
            )
            Icons.handPointIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, Constants.pointerIconSize / 2)
                .frame(height: Constants.pointerIconSize)
        }
    }
}

private extension ChooseLocationView {
    enum Constants {
        static let pointerIconSize: CGFloat = 100.0
    }
}

#if DEBUG
    #Preview {
        ChooseLocationView(
            store: .init(
                initialState: .init(), reducer: {
                    ChooseLocationFeature()
                }
            )
        )
    }
#endif
