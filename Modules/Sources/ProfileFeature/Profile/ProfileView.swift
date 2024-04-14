//
//  ProfileView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture
import FHCommon

public struct ProfileView: View {
    @Perception.Bindable private var store: StoreOf<ProfileFeature>

    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                headerView()
                
                contentView()

                logOutButton()
            }
            .navigationDestination(for: ProfileNavigationDestination.self) { destination in
                switch destination {
                case .personalInformation:
                    // TODO: add views
                    Text("Personal Info")
                case .yourSpace:
                    Text("YourSpace")
                default:
                    EmptyView()
                }
            }
            .alert(
                $store.scope(state: \.switchToHostAlert, action: \.switchToHostAlert)
            )
            .onAppear {
                store.send(.onAppear)
            }
        }
    }

    @ViewBuilder private func headerView() -> some View {
        VStack(alignment: .leading) {
            Text(Strings.profileTabTitle)
                .font(.title)

            if let user = store.user {
                NavigationLink(value: ProfileNavigationDestination.personalInformation) {
                    HStack {
                        ProfileUserView(
                            configuration: .init(user: user)
                        )
                        Spacer()
                        Icons.chevronRight
                            .fontWeight(.medium)
                    }
                }
                .foregroundStyle(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    @ViewBuilder private func contentView() -> some View {
        List(store.sections) { section in
            ProfileSectionView(section: section) {
                store.send(.requestSwitchToHost)
            }
        }
    }

    @ViewBuilder private func logOutButton() -> some View {
        Button {
            store.send(.logOut)
        } label: {
            Text(Strings.logOutButton)
                .underline()
        }
        .underline()
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .bottom])
    }
}

#if DEBUG
import FHRepository

    #Preview {
        NavigationStack {
            ProfileView(
                store: .init(
                    initialState: .init(), reducer: {
                        ProfileFeature()
                    }, withDependencies: {
                        $0.accountRepository = .previewValue
                    }
                )
            )
        }
    }
#endif
