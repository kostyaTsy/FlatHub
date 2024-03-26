//
//  LoginView.swift
//  
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import SwiftUI
import FHCommon
import ComposableArchitecture

public struct LoginView: View {
    private let store: StoreOf<LoginFeature>

    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text(Strings.loginTitle)
                .font(.system(size: Constants.titleFontSize))
                .fontWeight(.medium)

            HStack {}
                .frame(height: Constants.titleSpacing)

            loginFormView()

            HStack {}
                .frame(height: Constants.loginFormSpacing)

            FHOvalButton(
                title: Strings.loginTitle,
                configuration: Constants.buttonConfiguration
            ) {

            }

            Spacer()

            Text(Strings.noAccountText)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Layout.Spacing.xSmall)

            Button(Strings.signUpButton) {

            }
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, Layout.Spacing.big)
        .padding(.top, Constants.topContentPadding)
        .padding(.bottom, Constants.bottomContentPadding)
    }

    @ViewBuilder private func loginFormView() -> some View {
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

extension LoginView {
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

#Preview {
    LoginView(
        store: .init(
            initialState: .init(), reducer: {
                LoginFeature()
            }
        )
    )
}
