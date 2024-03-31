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
    @Perception.Bindable private var store: StoreOf<RegisterFeature>

    public init(store: StoreOf<RegisterFeature>) {
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
            Text(Strings.signUpTitle)
                .font(.system(size: Constants.titleFontSize))
                .fontWeight(.medium)

            HStack {}
                .frame(height: Constants.titleSpacing)

            signUpFormView()

            HStack {}
                .frame(height: Constants.loginFormSpacing)

            if let errorText = store.errorText {
                FHErrorText(text: errorText)
            }

            if store.isRegisterProcessing {
                ProgressView()
            }

            FHOvalButton(
                title: Strings.signUpTitle,
                disabled: !store.isRegisterButtonEnabled || store.isRegisterProcessing,
                configuration: Constants.buttonConfiguration
            ) {
                store.send(.performRegister)
            }

            Spacer()
        }
        .padding(.horizontal, Layout.Spacing.big)
        .padding(.top, Constants.topContentPadding)
        .padding(.bottom, Constants.bottomContentPadding)
    }

    @ViewBuilder private func signUpFormView() -> some View {
        VStack {
            // Username text field
            FHLineTextField(
                value: $store.username.sending(\.usernameChanged),
                topText: Strings.signUpUsernameFieldText,
                placeholder: Strings.signUpUsernamePlaceholder,
                configuration: Constants.textFieldConfiguration
            )
            .padding(.bottom, Layout.Spacing.medium)

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
            .padding(.bottom, Layout.Spacing.medium)

            // Confirm password text field
            FHLineTextField(
                value: $store.confirmedPasswordString.sending(\.confirmedPasswordChanged),
                isSecured: true,
                topText: Strings.authConfirmPasswordFieldText,
                placeholder: Strings.authPasswordPlaceholder,
                configuration: Constants.textFieldConfiguration
            )
        }
    }
}

// MARK: - Constants

extension RegisterView {
    private enum Constants {
        static let topContentPadding: CGFloat = 50
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
