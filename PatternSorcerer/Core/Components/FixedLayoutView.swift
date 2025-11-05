//
//  FixedLayoutView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import SwiftUI

/// Standard fixed layout wrapper for all main content views
/// Ensures consistent layout structure across all navigation items
struct FixedLayoutView<LeftContent: View, RightContent: View>: View {
    let leftContent: () -> LeftContent
    let rightContent: () -> RightContent
    let leftMinWidth: CGFloat
    let rightMinWidth: CGFloat

    init(
        leftMinWidth: CGFloat = 400,
        rightMinWidth: CGFloat = 400,
        @ViewBuilder leftContent: @escaping () -> LeftContent,
        @ViewBuilder rightContent: @escaping () -> RightContent
    ) {
        self.leftMinWidth = leftMinWidth
        self.rightMinWidth = rightMinWidth
        self.leftContent = leftContent
        self.rightContent = rightContent
    }

    var body: some View {
        HSplitView {
            // Left side
            leftContent()
                .frame(minWidth: leftMinWidth)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            Divider()

            // Right side
            rightContent()
                .frame(minWidth: rightMinWidth)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
