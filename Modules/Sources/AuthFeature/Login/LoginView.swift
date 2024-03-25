//
//  LoginView.swift
//  
//
//  Created by Kostya Tsyvilko on 24.03.24.
//

import SwiftUI
import ComposableArchitecture

public struct LoginView: View {
    private let store: StoreOf<LoginFeature>

    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("LoginView")
    }
}
