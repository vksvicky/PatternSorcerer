//
//  SyntaxToken.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation
import SwiftUI

/// Represents a syntax token in a regex pattern
struct SyntaxToken: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let type: TokenType
    let range: NSRange

    enum TokenType: String, CaseIterable {
        case characterClass
        case quantifier
        case anchor
        case captureGroup
        case escapeSequence
        case alternation
        case characterSet
        case literal
        case special

        var color: Color {
            switch self {
            case .characterClass:
                return .blue
            case .quantifier:
                return .purple
            case .anchor:
                return .orange
            case .captureGroup:
                return .green
            case .escapeSequence:
                return .cyan
            case .alternation:
                return .red
            case .characterSet:
                return .indigo
            case .literal:
                return .primary
            case .special:
                return .secondary
            }
        }
    }
}
