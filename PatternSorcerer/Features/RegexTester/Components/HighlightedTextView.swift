//
//  HighlightedTextView.swift
//  PatternSorcerer
//
//  SwiftUI view for displaying text with regex match highlights
//

import SwiftUI
import AppKit

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
        let textStorage = textView.textStorage!
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
        let textStorage = textView.textStorage!
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
            parent.text = textView.string
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

        self.init(cgColor: nsColor.cgColor)!
    }
}

