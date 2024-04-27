//
//  LazyTabView.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import SwiftUI

public struct LazyTabView<Content: View>: View {
    @Binding private var selectedID: Int
    @ViewBuilder var content: () -> Content

    public init(
        selectedID: Binding<Int> = .constant(0),
        content: @escaping () -> Content
    ) {
        self._selectedID = selectedID
        self.content = content
    }

    public var body: some View {
        GeometryReader { geo in
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem(.flexible())], spacing: .zero) {
                        content()
                            .padding(.top, geo.safeAreaInsets.top)
                            .padding(.leading, geo.safeAreaInsets.leading)
                            .padding(.trailing, geo.safeAreaInsets.trailing)
                            .frame(width: geo.size.width + geo.safeAreaInsets.trailing + geo.safeAreaInsets.leading)
                    }
                    .pagedScrollingTarget()
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        scrollViewProxy.scrollTo(selectedID, anchor: nil)
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .enablePagedScrolling()
            }
        }
    }
}

#if DEBUG
    #Preview {
        LazyTabView {
            ForEach(0...100_000, id: \.self) { index in
                Text("\(index)")
            }
        }
        .frame(height: 300)
        .background(.red)
    }
#endif
