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
    @Perception.Bindable private var store: StoreOf<LoginFeature>

    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            contentView()
                .background(Colors.system)
                .onTapGesture {
                    hideKeyboard()
                }
        }
    }

    @ViewBuilder private func contentView() -> some View {
        VStack {
            Text(Strings.loginTitle)
                .font(.system(size: Constants.titleFontSize))
                .fontWeight(.medium)

            HStack {}
                .frame(height: Constants.titleSpacing)

            loginFormView()

            HStack {}
                .frame(height: Constants.loginFormSpacing)

            if let errorText = store.errorText {
                FHErrorText(text: errorText)
            }

            if store.isLoginProcessing {
                ProgressView()
            }

            FHOvalButton(
                title: Strings.loginTitle,
                disabled: !store.isLoginButtonEnabled || store.isLoginProcessing,
                configuration: Constants.buttonConfiguration
            ) {
                store.send(.performLogin)
            }

            Spacer()

            Text(Strings.noAccountText)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Layout.Spacing.xSmall)

            Button(Strings.signUpButton) {
                store.send(.signUpButtonTapped)
            }
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, Layout.Spacing.big)
        .padding(.top, Constants.topContentPadding)
        .padding(.bottom, Constants.bottomContentPadding)
        .navigationDestination(
            store: store.scope(
                state: \.$destination.signUp,
                action: \.destination.signUp
            )
        ) { store in
            RegisterView(store: store)
        }
    }

    @ViewBuilder private func loginFormView() -> some View {
        VStack {
            // Email text field
            FHLineTextField(
                value: $store.emailString.sending(\.emailChanged),
                topText: Strings.authEmailFieldText,
                placeholder: Strings.authEmailPlaceholder,
                configuration: Constants.textFieldConfiguration
            )
            .padding(.bottom, Layout.Spacing.medium)

            // Password text field
            FHLineTextField(
                value: $store.passwordString.sending(\.passwordChanged),
                isSecured: true,
                topText: Strings.authPasswordFieldText,
                placeholder: Strings.authPasswordPlaceholder,
                configuration: Constants.textFieldConfiguration
            )
        }
    }
}

// MARK: - Constants

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

#if DEBUG
    #Preview {
        LoginView(
            store: .init(
                initialState: .init(), reducer: {
                    LoginFeature()
                }
            )
        )
    }
#endif
