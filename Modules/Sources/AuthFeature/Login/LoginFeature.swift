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

    @ObservableState
    public struct State {
        @Presents var destination: Destination.State?
        var isLoginButtonDisabled: Bool = true
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
                state.isLoginButtonDisabled = state.emailString.isEmpty || state.passwordString.isEmpty
                return .none
            case .signUpButtonTapped:
                state.destination = .signUp(RegisterFeature.State())
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) 

//        Scope(state: \.signUp, action: \.signUp) {
//            RegisterFeature()
//        }
    }
}

// MARK: - Destination

extension LoginFeature {
    @Reducer
    public enum Destination {
        case signUp(RegisterFeature)
    }
}
