//
//  PagedScrollingTarget.swift
//  
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import SwiftUI

/// This modifier is attached to the target View of the EnablePagedScrolling modifier
/// and allows for backward compatibility without causing errors.
struct PagedScrollingTarget: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .scrollTargetLayout()
        } else {
            content
        }
    }
}

public extension View {
    func pagedScrollingTarget() -> some View {
        modifier(PagedScrollingTarget())
    }
}
