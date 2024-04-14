//
//  LoginFeature.swift
//
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import FHAuth
import ComposableArchitecture

@Reducer
public struct LoginFeature {
    @Reducer
    public enum Destination {
        case signUp(RegisterFeature)
    }

    @ObservableState
    public struct State {
        @Presents var destination: Destination.State?
        var isLoginButtonEnabled: Bool = false
        var isLoginProcessing: Bool = false
        var emailString: String = ""
        var passwordString: String = ""
        var errorText: String?

        public init() {}
    }

    public enum Action {
        case destination(PresentationAction<Destination.Action>)

        case performLogin
        case loginStarted
        case loginFailure(Error)
        case loginSuccess
        case registerSuccess
        case emailChanged(String)
        case passwordChanged(String)
        case validateAuthData
        case signUpButtonTapped
    }

    @Dependency(\.authService) var authService

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .performLogin:
                let email = state.emailString
                let password = state.passwordString
                return .run { send in
                    do {
                        await send(.loginStarted)
                        try await authService.signIn(email, password)
                        await send(.loginSuccess)
                    } catch {
                        await send(.loginFailure(error))
                    }
                }
            case .loginStarted:
                state.errorText = nil
                state.isLoginProcessing = true
                return .none
            case .loginFailure(let error):
                state.isLoginProcessing = false
                state.errorText = error.localizedDescription
                return .none
            case .loginSuccess:
                state.isLoginProcessing = false
                return .none
            case .emailChanged(let email):
                state.emailString = email
                return .send(.validateAuthData)
            case .passwordChanged(let password):
                state.passwordString = password
                return .send(.validateAuthData)
            case .validateAuthData:
                state.isLoginButtonEnabled = validateUserInput(for: state)
                return .none
            case .signUpButtonTapped:
                state.destination = .signUp(RegisterFeature.State())
                return .none
            case .destination(.presented(.signUp(.registerSuccess))):
                state.destination = nil
                return .run { send in
                    await send(.registerSuccess)
                }
            case .destination, .registerSuccess:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

private extension LoginFeature {
    func validateUserInput(for state: State) -> Bool {
        !state.emailString.isEmpty && !state.passwordString.isEmpty
    }
}
