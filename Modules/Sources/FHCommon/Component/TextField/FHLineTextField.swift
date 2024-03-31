//
//  FHLineTextField.swift
//
//
//  Created by Kostya Tsyvilko on 25.03.24.
//

import SwiftUI

public struct FHLineTextField: View {
    public struct Configuration {
        let eyeIconColor: Color
        let topTextColor: Color
        let autocorrectionEnabled: Bool
        let textAutocapitalization: TextInputAutocapitalization

        public init(
            eyeIconColor: Color = .gray,
            topTextColor: Color = .primary,
            autocorrectionEnabled: Bool = true,
            textAutocapitalization: TextInputAutocapitalization = .never
        ) {
            self.eyeIconColor = eyeIconColor
            self.topTextColor = topTextColor
            self.autocorrectionEnabled = autocorrectionEnabled
            self.textAutocapitalization = textAutocapitalization
        }
    }

    @Binding private var value: String
    private let isSecured: Bool
    private let topText: String?
    private let placeholder: String
    private let configuration: Configuration

    /// State for changing secure text field state
    @State private var _isSecured: Bool = false

    public init(
        value: Binding<String>,
        isSecured: Bool = false,
        topText: String? = nil,
        placeholder: String = "",
        configuration: Configuration = Configuration()
    ) {
        self._value = value
        self.topText = topText
        self.isSecured = isSecured
        self.placeholder = placeholder
        self.configuration = configuration

        if isSecured {
            self.__isSecured = State(initialValue: isSecured)
        }
    }

    public var body: some View {
        VStack(alignment: .leading) {
            if let topText {
                Text(topText)
                    .foregroundStyle(configuration.topTextColor)
                    .padding(.bottom, Layout.Spacing.xSmall)
            }

            textFieldContent()
        }
    }

    @ViewBuilder private func textFieldContent() -> some View {
        ZStack(alignment: .trailing) {
            VStack {
                if _isSecured {
                    SecureField(placeholder, text: $value)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled(configuration.autocorrectionEnabled)
                        .textInputAutocapitalization(configuration.textAutocapitalization)
                } else {
                    TextField(placeholder, text: $value)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled(configuration.autocorrectionEnabled)
                        .textInputAutocapitalization(configuration.textAutocapitalization)
                }
                Divider()
            }

            if isSecured {
                Button {
                    _isSecured.toggle()
                } label: {
                    _isSecured ?
                    Icons.eyeSlashIcon.tint(configuration.eyeIconColor) :
                    Icons.eyeIcon.tint(configuration.eyeIconColor)
                }
            }
        }
    }
}

#Preview {
    FHLineTextField(value: .constant("123"), isSecured: true, topText: "123")
}
