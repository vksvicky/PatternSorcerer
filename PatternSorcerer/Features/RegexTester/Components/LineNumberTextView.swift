//
//  LineNumberTextView.swift
//  PatternSorcerer
//
//  Text editor with line numbers
//
//  Created on $(date)
//

import SwiftUI
import AppKit

struct LineNumberTextView: NSViewRepresentable {
    @Binding var text: String
    @Binding var showLineNumbers: Bool
    var fontSize: CGFloat = 13
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView
        
        // Configure text view
        textView.font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.allowsUndo = true
        
        // Store reference
        context.coordinator.textView = textView
        context.coordinator.scrollView = scrollView
        
        // Set up line number view if enabled
        if showLineNumbers {
            setupLineNumberView(for: scrollView)
        }
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        
        // Update text if changed externally
        if textView.string != text {
            textView.string = text
        }
        
        // Update font size
        textView.font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        
        // Update line numbers
        if showLineNumbers {
            if nsView.subviews.count == 1 {
                setupLineNumberView(for: nsView)
            }
        } else {
            removeLineNumberView(from: nsView)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    private func setupLineNumberView(for scrollView: NSScrollView) {
        // Create line number view
        let lineNumberView = LineNumberRulerView(textView: scrollView.documentView as! NSTextView)
        lineNumberView.font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        lineNumberView.backgroundColor = NSColor.controlBackgroundColor
        lineNumberView.textColor = NSColor.secondaryLabelColor
        
        scrollView.hasVerticalRuler = true
        scrollView.hasHorizontalRuler = false
        scrollView.rulersVisible = true
        scrollView.verticalRulerView = lineNumberView
    }
    
    private func removeLineNumberView(from scrollView: NSScrollView) {
        scrollView.rulersVisible = false
        scrollView.verticalRulerView = nil
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String
        var textView: NSTextView?
        var scrollView: NSScrollView?
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            text = textView.string
        }
    }
}

// MARK: - Line Number Ruler View

class LineNumberRulerView: NSRulerView {
    var font: NSFont = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    var textColor: NSColor = .secondaryLabelColor
    var backgroundColor: NSColor = .controlBackgroundColor
    
    override init(scrollView: NSScrollView?, orientation: NSRulerView.Orientation) {
        super.init(scrollView: scrollView, orientation: orientation)
        clientView = scrollView?.documentView
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textView: NSTextView) {
        self.init(scrollView: nil, orientation: .vertical)
        clientView = textView
    }
    
    override func draw(_ dirtyRect: NSRect) {
        backgroundColor.setFill()
        dirtyRect.fill()
        
        guard let textView = clientView as? NSTextView,
              let layoutManager = textView.layoutManager,
              let textContainer = textView.textContainer else {
            return
        }
        
        let visibleRect = textView.visibleRect
        let visibleRange = layoutManager.glyphRange(forBoundingRect: visibleRect, in: textContainer)
        
        if visibleRange.location == NSNotFound {
            return
        }
        
        let firstVisibleGlyph = visibleRange.location
        let firstVisibleCharIndex = layoutManager.characterIndexForGlyph(at: firstVisibleGlyph)
        let string = textView.string as NSString
        let lineRange = string.lineRange(for: NSRange(location: firstVisibleCharIndex, length: 0))
        var lineNumber = string.lineNumber(for: lineRange.location)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        
        var glyphIndex = firstVisibleGlyph
        while glyphIndex < NSMaxRange(visibleRange) {
            let charIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
            let lineRange = string.lineRange(for: NSRange(location: charIndex, length: 0))
            let glyphRange = layoutManager.glyphRange(forCharacterRange: lineRange, actualCharacterRange: nil)
            let rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
            
            let lineNumberString = "\(lineNumber)"
            let stringSize = lineNumberString.size(withAttributes: attributes)
            let x = ruleThickness - stringSize.width - 5
            let y = rect.origin.y + (rect.height - stringSize.height) / 2
            
            lineNumberString.draw(at: NSPoint(x: x, y: y), withAttributes: attributes)
            
            glyphIndex = NSMaxRange(glyphRange)
            lineNumber += 1
        }
    }
    
    override var ruleThickness: CGFloat {
        get {
            let maxLineNumber = 9999
            let lineNumberString = "\(maxLineNumber)"
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            let size = lineNumberString.size(withAttributes: attributes)
            return size.width + 10
        }
        set {
            // Ignored
        }
    }
}

// MARK: - NSString Extension

extension NSString {
    func lineNumber(for location: Int) -> Int {
        var lineNumber = 1
        var index = 0
        
        while index < location && index < length {
            let range = NSRange(location: index, length: 1)
            let char = substring(with: range)
            
            if char == "\n" {
                lineNumber += 1
            }
            
            index += 1
        }
        
        return lineNumber
    }
}

