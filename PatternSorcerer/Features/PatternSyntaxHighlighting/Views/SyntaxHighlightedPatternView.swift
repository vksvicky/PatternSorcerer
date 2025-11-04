//
//  SyntaxHighlightedPatternView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import SwiftUI

struct SyntaxHighlightedPatternView: View {
    let pattern: String
    private let highlighter = PatternSyntaxHighlighter()

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(highlighter.highlight(pattern: pattern)) { token in
                Text(token.text)
                    .foregroundColor(token.type.color)
                    .font(.system(.caption, design: .monospaced))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(4)
    }
}
