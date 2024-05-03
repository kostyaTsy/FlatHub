//
//  ReviewContainer.swift
//  
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import SwiftUI
import FHCommon

struct ReviewContainer: View {

    private let title: String
    @Binding private var chosenRate: Int
    private let placeholder: String
    @Binding private var text: String

    init(
        title: String,
        chosenRate: Binding<Int>,
        placeholder: String,
        text: Binding<String>
    ) {
        self.title = title
        self._chosenRate = chosenRate
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        content()
            .padding(Layout.Spacing.smallMedium)
    }

    @ViewBuilder private func content() -> some View {
        VStack(spacing: Layout.Spacing.medium) {
            Text(title)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            starsView()
            textContent()
        }
    }

    @ViewBuilder private func textContent() -> some View {
        TextField(
            placeholder,
            text: $text,
            axis: .vertical
        )
        .lineLimit(Constants.textFieldLines, reservesSpace: true)
        .textFieldStyle(.roundedBorder)
    }

    @ViewBuilder private func starsView() -> some View {
        HStack {
            ForEach(1..<6) { rate in
                Image(systemName: chosenRate >= rate ? Icons.startFillIconName : Icons.startIconName)
                    .font(.largeTitle)
                    .onTapGesture {
                        let impactTouch = UIImpactFeedbackGenerator(style: .medium)
                        if chosenRate != rate {
                            impactTouch.impactOccurred()
                            chosenRate = rate
                        }
                    }
            }
        }
    }
}

private extension ReviewContainer {
    enum Constants {
        static let textFieldLines: Int = 6
    }
}

#if DEBUG
    #Preview {
        ReviewContainer(
            title: "Title",
            chosenRate: .constant(2),
            placeholder: "Test",
            text: .constant("")
        )
    }
#endif
