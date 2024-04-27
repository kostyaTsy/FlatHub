//
//  AddPriceView.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import SwiftUI
import FHCommon

struct AddPriceView: View {
    @Perception.Bindable private var store: StoreOf<AddPriceFeature>

    init(store: StoreOf<AddPriceFeature>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            content()
                .padding(.horizontal, Layout.Spacing.smallMedium)
                .background(Colors.system)
                .onTapGesture {
                    hideKeyboard()
                }
                .onDisappear {
                    hideKeyboard()
                }
        }
    }

    @ViewBuilder private func content() -> some View {
        FHContentView(
            title: Strings.addPriceTitle,
            subtitle: Strings.addPriceSubtitle
        ) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    textFieldContent()
                    Text(Strings.currencySign)
                        .font(Constants.currencyFont)
                        .padding(.bottom, Layout.Spacing.small)
                    Spacer()
                }
                .padding(.bottom, Constants.textFieldBottomPadding)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Layout.Spacing.medium)
    }

    @ViewBuilder private func textFieldContent() -> some View {
        VStack {
            TextField(
                Strings.empty,
                text: $store.price.sending(\.onPriceChanged)
            )
            .keyboardType(.numberPad)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.trailing)
            .frame(width: Constants.textFieldWidth)
            .font(Constants.textFieldFont)

            Divider()
                .frame(width: Constants.textFieldWidth)
        }
    }
}

private extension AddPriceView {
    enum Constants {
        static let textFieldWidth: CGFloat = 150.0
        static let textFieldBottomPadding: CGFloat = 150.0
        static let textFieldFont = Font.system(size: 40, weight: .bold)
        static let currencyFont = Font.system(size: 44, weight: .bold)
    }
}

#Preview {
    AddPriceView(
        store: .init(
            initialState: .init(), reducer: {
                AddPriceFeature()
            }
        )
    )
}
