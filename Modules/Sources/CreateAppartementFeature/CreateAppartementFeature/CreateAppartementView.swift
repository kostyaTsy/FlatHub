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
                contentView()
                footerView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {

                    } label: {
                        Text(Strings.navigationExitButtonTitle)
                            .underline()
                    }
                    .foregroundStyle(.black)
                }
            }
        }
    }

    @ViewBuilder private func contentView() -> some View {
        TabView(selection: .constant(1)) {
            VStack {
                Text("1")
                Spacer()
            }
            Text("2")
            Text("3")
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = false
        }
    }

    @ViewBuilder private func footerView() -> some View {
        VStack(spacing: .zero) {
            ProgressView(value: 10, total: 100)
            HStack {
                Button {

                } label: {
                    Text(Strings.navigationBackButtonTitle)
                        .underline()
                }
                .foregroundStyle(.black)

                Spacer()
                FHOvalButton(
                    title: Strings.navigationNextButtonTitle,
                    configuration: Constants.nextButtonConfiguration
                ) {

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
                    }
                )
            )
        }
    }
#endif
