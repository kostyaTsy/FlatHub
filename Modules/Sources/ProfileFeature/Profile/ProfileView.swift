//
//  ProfileView.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import SwiftUI
import ComposableArchitecture

public struct ProfileView: View {
    private let store: StoreOf<ProfileFeature>

    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Profile")
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
