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
            Button(Strings.logOutButton) {
                store.send(.logOut)
            }
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
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
