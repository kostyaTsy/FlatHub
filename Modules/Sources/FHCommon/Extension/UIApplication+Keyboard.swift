//
//  UIApplication+Keyboard.swift
//
//
//  Created by Kostya Tsyvilko on 30.03.24.
//

import SwiftUI

public extension View {
    func hideKeyboard() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
    }
}
