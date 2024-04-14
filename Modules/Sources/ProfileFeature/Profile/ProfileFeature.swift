//
//  ProfileFeature.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import ComposableArchitecture
import FHRepository
import FHAuth
import FHCommon

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State {
        var sections: [ProfileSection] = []
        var user: User!

        @Presents var switchToHostAlert: AlertState<SwitchToHostAlertAction>?

        public init() {}
    }

    public enum Action {
        case onAppear
        case requestSwitchToHost
        case switchToHostAlert(PresentationAction<SwitchToHostAlertAction>)
        case confirmedSwitchToHost
        case switchToHost // All steps done and Host View can be shown
        case switchToHostError(Error)
        case logOut
        case logOutSuccess
    }

    public enum SwitchToHostAlertAction {
        case confirmed
    }

    @Dependency(\.accountRepository) var accountRepository
    @Dependency(\.authService) var authService

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let user = accountRepository.user()
                state.user = user
                state.sections = ProfileModelBuilder.build(for: user)
                return .none
            case .requestSwitchToHost:
                if !state.user.isHost {
                    state.switchToHostAlert = getSwitchToHostAlert()
                    return .none
                } else {
                    return .send(.switchToHost)
                }
            case .switchToHostAlert(.presented(.confirmed)):
                return .send(.confirmedSwitchToHost)
            case .switchToHostAlert:
                return .none
            case .confirmedSwitchToHost:
                let user = state.user
                return .run { send in
                    guard let user else { return }
                    do {
                        try await accountRepository.becomeHost(user)
                        await send(.switchToHost)
                    } catch {
                        await send(.switchToHostError(error))
                    }
                }
            case .switchToHost:
                accountRepository.updateUserRole(.host)
                return .none
            case .switchToHostError(_):
                // TODO: handle error
                return .none
            case .logOut:
                do {
                    try authService.signOut()
                    return .send(.logOutSuccess)
                } catch {
                    return .none
                }
            case .logOutSuccess:
                return .none
            }
        }
    }
}

// MARK: - Alert

private extension ProfileFeature {
    private func getSwitchToHostAlert() -> AlertState<SwitchToHostAlertAction> {
        AlertState {
            TextState(Strings.switchToHostingAlertQuestion)
        } actions: {
            ButtonState(role: .cancel) {
                TextState(Strings.alertNoButtonText)
            }
            ButtonState(action: .confirmed) {
                TextState(Strings.alertYesButtonText)
            }
        }
    }
}
