//
//  View+Keyboard.swift
//
//
//  Created by Kostya Tsyvilko on 30.03.24.
//

import SwiftUI

public extension View {
    func hideKeyboard() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
