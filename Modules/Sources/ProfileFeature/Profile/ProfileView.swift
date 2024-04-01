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
                contentView()

                logOutButton()
            }
        }
        .navigationDestination(for: ProfileNavigationDestination.self) { destination in
            switch destination {
            case .personalInformation:
                Text("Personal Info")
            default:
                Text("Hosting")
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

    @ViewBuilder private func contentView() -> some View {
        List {
            ForEach(store.sections) { section in
                ProfileSectionView(section: section)
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
    #Preview {
        ProfileView(
            store: .init(
                initialState: .init(), reducer: {
                    ProfileFeature()
                }
            )
        )
    }
#endif
