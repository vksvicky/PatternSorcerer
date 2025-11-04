//
//  BacktrackingVisualizer.swift
//  PatternSorcerer
//
//  Unique feature: Visualizes regex backtracking behavior
//
//  Created on $(date)
//

import Foundation
import SwiftUI

/// Visualizes regex backtracking behavior
class BacktrackingVisualizer {

    /// Analyze backtracking potential
    func analyzeBacktracking(pattern: String, text: String) -> BacktrackingAnalysis {
        var warnings: [BacktrackingWarning] = []
        var complexity: Int = 0

        // Check for catastrophic backtracking patterns
        if pattern.contains(".*.*") || pattern.contains(".+.*") {
            warnings.append(.catastrophicBacktracking)
            complexity += 50
        }

        // Check for nested quantifiers
        if hasNestedQuantifiers(pattern) {
            warnings.append(.nestedQuantifiers)
            complexity += 30
        }

        // Check for alternation with quantifiers
        if hasQuantifiedAlternation(pattern) {
            warnings.append(.quantifiedAlternation)
            complexity += 20
        }

        // Check pattern length vs text length
        if pattern.count > text.count * 2 {
            warnings.append(.inefficientPattern)
            complexity += 10
        }

        let riskLevel: BacktrackingRiskLevel = {
            if complexity >= 50 {
                return .high
            } else if complexity >= 30 {
                return .medium
            } else {
                return .low
            }
        }()

        return BacktrackingAnalysis(
            riskLevel: riskLevel,
            warnings: warnings,
            suggestions: generateSuggestions(warnings)
        )
    }

    private func hasNestedQuantifiers(_ pattern: String) -> Bool {
        // Simple check for nested quantifiers
        return pattern.contains("(.*)+") || pattern.contains("(.+)*")
    }

    private func hasQuantifiedAlternation(_ pattern: String) -> Bool {
        // Check for quantified alternation like (a|b)* or (foo|bar)+
        // We require a '|' inside the group before a quantifier
        let patternLength = (pattern as NSString).length
        let groupWithQuantifier = try? NSRegularExpression(
            pattern: "\\((?:[^()]*\\|[^()]*)\\)([+*?])",
            options: []
        )
        if let match = groupWithQuantifier?.firstMatch(in: pattern, options: [], range: NSRange(location: 0, length: patternLength)) {
            return match.range.location != NSNotFound
        }
        return false
    }

    private func generateSuggestions(_ warnings: [BacktrackingWarning]) -> [String] {
        var suggestions: [String] = []

        if warnings.contains(.catastrophicBacktracking) {
            suggestions.append("Use possessive quantifiers (*+, ++) or atomic groups")
            suggestions.append("Make the pattern more specific")
        }

        if warnings.contains(.nestedQuantifiers) {
            suggestions.append("Flatten nested quantifiers")
            suggestions.append("Use non-capturing groups with specific patterns")
        }

        if warnings.contains(.quantifiedAlternation) {
            suggestions.append("Consider character classes instead of alternation")
        }

        if warnings.contains(.inefficientPattern) {
            suggestions.append("Simplify the pattern")
            suggestions.append("Break into multiple patterns if needed")
        }

        return suggestions
    }
}

// MARK: - Models

struct BacktrackingAnalysis {
    let riskLevel: BacktrackingRiskLevel
    let warnings: [BacktrackingWarning]
    let suggestions: [String]
}

enum BacktrackingRiskLevel {
    case low
    case medium
    case high

    var color: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }

    var description: String {
        switch self {
        case .low:
            return "Low Risk"
        case .medium:
            return "Medium Risk"
        case .high:
            return "High Risk"
        }
    }
}

enum BacktrackingWarning: Hashable {
    case catastrophicBacktracking
    case nestedQuantifiers
    case quantifiedAlternation
    case inefficientPattern

    var description: String {
        switch self {
        case .catastrophicBacktracking:
            return "Potential catastrophic backtracking"
        case .nestedQuantifiers:
            return "Nested quantifiers detected"
        case .quantifiedAlternation:
            return "Quantified alternation may cause backtracking"
        case .inefficientPattern:
            return "Pattern may be inefficient"
        }
    }
}

// Color reference is in the enum definition above

