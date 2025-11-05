//
//  EmptyStateView.swift
//  PatternSorcerer
//
//  Reusable empty state view component
//
//  Created on 2025-12-XX
//

import SwiftUI

/// Empty state view with icon and message
func emptyStateView(icon: String, message: String) -> some View {
    VStack(spacing: 16) {
        Spacer()
        Image(systemName: icon)
            .font(.system(size: 48))
            .foregroundColor(.secondary)
        Text(message)
            .font(.title3)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
