//
//  RegisterView.swift
//
//
//  Created by Kostya Tsyvilko on 26.03.24.
//

import SwiftUI
import FHCommon
import ComposableArchitecture

public struct RegisterView: View {
    private let store: StoreOf<RegisterFeature>

    public init(store: StoreOf<RegisterFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text(Strings.signUpTitle)
                .font(.system(size: Constants.titleFontSize))
                .fontWeight(.medium)

            HStack {}
                .frame(height: Constants.titleSpacing)

            signUpFormView()

            HStack {}
                .frame(height: Constants.loginFormSpacing)

            FHOvalButton(
                title: Strings.signUpTitle,
                configuration: Constants.buttonConfiguration
            ) {

            }

            Spacer()
        }
        .padding(.horizontal, Layout.Spacing.big)
        .padding(.top, Constants.topContentPadding)
        .padding(.bottom, Constants.bottomContentPadding)
    }

    @ViewBuilder private func signUpFormView() -> some View {
        VStack {
            FHLineTextField(
                value: .constant(""),
                topText: Strings.authEmailFieldText,
                placeholder: Strings.authEmailPlaceholder,
                configuration: Constants.textFieldConfiguration
            )
            .padding(.bottom, Layout.Spacing.medium)

            FHLineTextField(
                value: .constant("123"),
                isSecured: true,
                topText: Strings.authPasswordFieldText,
                placeholder: Strings.authPasswordPlaceholder,
                configuration: Constants.textFieldConfiguration
            )
        }
    }
}

// MARK: - Constants

extension RegisterView {
    private enum Constants {
        static let topContentPadding: CGFloat = 100
        static let bottomContentPadding: CGFloat = 30
        static let titleFontSize: CGFloat = 30
        static let titleSpacing: CGFloat = 70
        static let loginFormSpacing: CGFloat = 50
        static let textFieldConfiguration = FHLineTextField.Configuration(autocorrectionEnabled: false, textAutocapitalization: .never)
        static let buttonConfiguration = FHOvalButton.Configuration(backgroundColor: .blue, foregroundColor: .white)
    }
}

#if DEBUG
    #Preview {
        RegisterView(
            store: .init(
                initialState: .init(), reducer: {
                    RegisterFeature()
                }
            )
        )
    }
#endif
