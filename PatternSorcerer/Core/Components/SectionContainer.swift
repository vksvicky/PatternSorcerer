//
//  SectionContainer.swift
//  PatternSorcerer
//
//  Reusable section container component with title and description
//
//  Created on 2025-12-XX
//

import SwiftUI

/// Section container with title, optional description, and styled content
struct SectionContainer<Content: View>: View {
    let title: String
    let description: String?
    let content: () -> Content

    init(title: String, description: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.description = description
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                if let description = description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)

            Divider()

            content()
                .padding(8)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
                )
        )
    }
}
