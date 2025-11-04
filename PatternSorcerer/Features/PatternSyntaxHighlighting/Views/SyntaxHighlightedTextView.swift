//
//  SyntaxHighlightedTextView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import SwiftUI

struct SyntaxHighlightedTextView: NSViewRepresentable {
    let pattern: String
    let highlighter: PatternSyntaxHighlighterProtocol

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.font = .monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        textView.backgroundColor = .textBackgroundColor
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else {
            return
        }

        let tokens = highlighter.highlight(pattern: pattern)
        let attributedString = NSMutableAttributedString()

        for token in tokens {
            let nsColor = colorToNSColor(token.type.color)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: nsColor,
                .font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
            ]
            attributedString.append(NSAttributedString(string: token.text, attributes: attributes))
        }

        textView.textStorage?.setAttributedString(attributedString)
    }

    private func colorToNSColor(_ color: Color) -> NSColor {
        // Convert SwiftUI Color to NSColor
        switch color {
        case .blue:
            return .systemBlue
        case .purple:
            return .systemPurple
        case .orange:
            return .systemOrange
        case .green:
            return .systemGreen
        case .cyan:
            return .systemTeal
        case .red:
            return .systemRed
        case .indigo:
            return .systemIndigo
        case .primary:
            return .labelColor
        case .secondary:
            return .secondaryLabelColor
        default:
            return .labelColor
        }
    }
}
