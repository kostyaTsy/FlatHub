//
//  RegisterFeature.swift
//  
//
//  Created by Kostya Tsyvilko on 26.03.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct RegisterFeature {
    @ObservableState
    public struct State {
        var isRegisterButtonEnabled: Bool = false
        var isRegisterProcessing: Bool = false
        var username: String = ""
        var emailString: String = ""
        var passwordString: String = ""
        var confirmedPasswordString: String = ""
        var errorText: String?

        public init() {}
    }

    public enum Action {
        case performRegister
        case registerStarted
        case registerFailure(Error)
        case registerSuccess
        case usernameChanged(String)
        case emailChanged(String)
        case passwordChanged(String)
        case confirmedPasswordChanged(String)
        case validateAuthData
    }

    public init() {}

    @Dependency(\.authService) var authService
    @Dependency(\.accountRepository) var accountRepository

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .performRegister:
                let email = state.emailString
                let password = state.passwordString
                let userDTO = UserDTO(userName: state.username, email: email)
                return .run { send in
                    do {
                        await send(.registerStarted)
                        try await authService.signUp(email, password)
                        try await accountRepository.save(userDTO)
                        await send(.registerSuccess)
                    } catch {
                        await send(.registerFailure(error))
                    }
                }
            case .registerStarted:
                state.errorText = nil
                state.isRegisterProcessing = true
                return .none
            case .registerFailure(let error):
                state.isRegisterProcessing = false
                state.errorText = error.localizedDescription
                return .none
            case .registerSuccess:
                state.isRegisterProcessing = false
                return .none
            case .usernameChanged(let username):
                state.username = username
                return .send(.validateAuthData)
            case .emailChanged(let email):
                state.emailString = email
                return .send(.validateAuthData)
            case .passwordChanged(let password):
                state.passwordString = password
                return .send(.validateAuthData)
            case .confirmedPasswordChanged(let confirmedPassword):
                state.confirmedPasswordString = confirmedPassword
                return .send(.validateAuthData)
            case .validateAuthData:
                state.isRegisterButtonEnabled = validateUserInput(for: state)
                return .none
            }
        }
    }
}

private extension RegisterFeature {
    func validateUserInput(for state: State) -> Bool {
        !state.username.isEmpty &&
        !state.emailString.isEmpty &&
        !state.passwordString.isEmpty &&
        state.passwordString == state.confirmedPasswordString
    }
}
