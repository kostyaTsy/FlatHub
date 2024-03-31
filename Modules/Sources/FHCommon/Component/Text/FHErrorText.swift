//
//  FHErrorText.swift
//
//
//  Created by Kostya Tsyvilko on 30.03.24.
//

import SwiftUI

public struct FHErrorText: View {
    private let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
    #Preview {
        FHErrorText(text: "Error")
    }
#endif
