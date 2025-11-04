//
//  HighlightedTextView.swift
//  PatternSorcerer
//
//  SwiftUI view for displaying text with regex match highlights
//
//  Created on 2025-11-04
//

import AppKit
import SwiftUI

/// View that displays text with highlighted matches and capture groups
struct HighlightedTextView: NSViewRepresentable {
    @Binding var text: String
    let highlightedText: HighlightedText?
    let showLineNumbers: Bool
    let fontSize: CGFloat

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()

        textView.isEditable = true
        textView.isSelectable = true
        textView.font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        textView.string = text

        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true

        context.coordinator.textView = textView

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }

        // Update text if changed
        if textView.string != text {
            textView.string = text
        }

        // Apply highlighting
        if let highlighted = highlightedText {
            applyHighlighting(to: textView, highlightedText: highlighted)
        } else {
            // Clear highlighting
            clearHighlighting(in: textView)
        }

        // Update text binding when user edits
        NotificationCenter.default.removeObserver(context.coordinator)
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.textDidChange),
            name: NSText.didChangeNotification,
            object: textView
        )
    }

    private func applyHighlighting(to textView: NSTextView, highlightedText: HighlightedText) {
        guard let textStorage = textView.textStorage else { return }
        let fullRange = NSRange(location: 0, length: textStorage.length)

        // Remove existing highlighting
        textStorage.removeAttribute(.backgroundColor, range: fullRange)

        // Apply new highlights
        for highlight in highlightedText.highlights {
            let range = highlight.range
            guard range.location < textStorage.length,
                  range.location + range.length <= textStorage.length else {
                continue
            }

            // Convert SwiftUI Color to NSColor
            let nsColor = NSColor(highlight.color)
            textStorage.addAttribute(.backgroundColor, value: nsColor, range: range)
        }
    }

    private func clearHighlighting(in textView: NSTextView) {
        guard let textStorage = textView.textStorage else { return }
        let fullRange = NSRange(location: 0, length: textStorage.length)
        textStorage.removeAttribute(.backgroundColor, range: fullRange)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: HighlightedTextView
        var textView: NSTextView?

        init(_ parent: HighlightedTextView) {
            self.parent = parent
        }

        @objc func textDidChange(_ notification: Notification) {
            guard let textView = textView else { return }
            let newText = textView.string

            // Only update if text actually changed to avoid unnecessary updates
            guard newText != parent.text else { return }

            // Defer binding update outside the current view update cycle
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.parent.text = newText
            }
        }
    }
}

// MARK: - NSColor Extension
extension NSColor {
    convenience init(_ color: Color) {
        // Convert SwiftUI Color to NSColor via CGColor
        // For SwiftUI colors, we need to render them in a context to get the CGColor
        let nsColor: NSColor

        // Handle common colors
        switch color {
        case .blue:
            nsColor = .systemBlue
        case .green:
            nsColor = .systemGreen
        case .orange:
            nsColor = .systemOrange
        case .purple:
            nsColor = .systemPurple
        case .pink:
            nsColor = .systemPink
        case .cyan:
            nsColor = .systemCyan
        case .yellow:
            nsColor = .systemYellow
        case .mint:
            nsColor = .systemMint
        case .teal:
            nsColor = .systemTeal
        case .indigo:
            nsColor = .systemIndigo
        default:
            // For custom colors, try to get CGColor from a rendered view
            // Fallback to system blue if conversion fails
            nsColor = .systemBlue
        }

        // Initialize NSColor with the determined color's components
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
