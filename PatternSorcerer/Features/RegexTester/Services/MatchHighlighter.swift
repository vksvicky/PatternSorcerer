//
//  MatchHighlighter.swift
//  PatternSorcerer
//
//  Service for highlighting matches and capture groups in text
//

import Foundation
import SwiftUI

/// Result of highlighting operation
struct HighlightedText {
    let text: String
    let highlights: [TextHighlight]
}

/// A highlight in the text
struct TextHighlight: Identifiable, Hashable {
    let id: UUID
    let range: NSRange
    let color: Color
    let type: HighlightType

    enum HighlightType: Hashable {
        case match(number: Int)
        case captureGroup(groupIndex: Int, matchNumber: Int)
    }
}

/// Service for highlighting regex matches in text
class MatchHighlighter {
    /// Create highlighted text from matches
    /// - Parameters:
    ///   - text: Original text
    ///   - matches: Array of match results
    ///   - highlightMatches: Whether to highlight full matches
    ///   - highlightCaptureGroups: Whether to highlight capture groups
    /// - Returns: Highlighted text with highlight information
    func highlight(
        text: String,
        matches: [MatchResult],
        highlightMatches: Bool = true,
        highlightCaptureGroups: Bool = true
    ) -> HighlightedText {
        var highlights: [TextHighlight] = []

        // Add match highlights
        if highlightMatches {
            for match in matches {
                highlights.append(TextHighlight(
                    id: UUID(),
                    range: match.range,
                    color: colorForMatch(match.matchNumber),
                    type: .match(number: match.matchNumber)
                ))
            }
        }

        // Add capture group highlights
        if highlightCaptureGroups {
            for match in matches {
                for group in match.captureGroups {
                    highlights.append(TextHighlight(
                        id: UUID(),
                        range: group.range,
                        color: colorForCaptureGroup(group.index),
                        type: .captureGroup(groupIndex: group.index, matchNumber: match.matchNumber)
                    ))
                }
            }
        }

        // Sort highlights by position
        highlights.sort { $0.range.location < $1.range.location }

        return HighlightedText(text: text, highlights: highlights)
    }

    // MARK: - Private Helpers

    private func colorForMatch(_ matchNumber: Int) -> Color {
        let colors: [Color] = [
            .blue,
            .green,
            .orange,
            .purple,
            .pink,
            .cyan
        ]
        return colors[(matchNumber - 1) % colors.count]
    }

    private func colorForCaptureGroup(_ groupIndex: Int) -> Color {
        let colors: [Color] = [
            .yellow,
            .mint,
            .teal,
            .indigo
        ]
        return colors[(groupIndex - 1) % colors.count].opacity(0.6)
    }
}

