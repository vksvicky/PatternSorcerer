//
//  PatternComplexityAnalyzer.swift
//  PatternSorcerer
//
//  Unique feature: Analyzes regex pattern complexity
//
//  Created on 2025-11-04
//

import Foundation
import SwiftUI

/// Analyzes regex pattern complexity and provides insights
class PatternComplexityAnalyzer {

    /// Calculate complexity score (0-100)
    func calculateComplexity(_ pattern: String) -> ComplexityScore {
        var score = 0

        // Length factor
        score += min(pattern.count / 10, 20)

        // Quantifier complexity
        let quantifierCount = pattern.components(separatedBy: CharacterSet(charactersIn: "*+?{")).count - 1
        score += min(quantifierCount * 2, 20)

        // Capture groups
        let groupCount = pattern.components(separatedBy: "(").count - 1
        score += min(groupCount * 3, 20)

        // Lookahead/lookbehind
        let lookaroundCount = (pattern.components(separatedBy: "(?=").count - 1) +
                              (pattern.components(separatedBy: "(?<=").count - 1)
        score += min(lookaroundCount * 5, 15)

        // Alternation
        let alternationCount = pattern.components(separatedBy: "|").count - 1
        score += min(alternationCount * 2, 15)

        // Character classes
        let classCount = pattern.components(separatedBy: "[").count - 1
        score += min(classCount, 10)

        let finalScore = min(score, 100)

        return ComplexityScore(
            score: finalScore,
            level: complexityLevel(for: finalScore),
            factors: analyzeFactors(pattern)
        )
    }

    private func complexityLevel(for score: Int) -> ComplexityLevel {
        switch score {
        case 0..<30:
            return .simple
        case 30..<60:
            return .moderate
        case 60..<80:
            return .complex
        default:
            return .veryComplex
        }
    }

    private func analyzeFactors(_ pattern: String) -> [ComplexityFactor] {
        var factors: [ComplexityFactor] = []

        if pattern.contains("(?=") || pattern.contains("(?<=") {
            factors.append(.lookaround)
        }

        if pattern.components(separatedBy: "|").count > 3 {
            factors.append(.manyAlternations)
        }

        if pattern.components(separatedBy: "(").count > 5 {
            factors.append(.manyGroups)
        }

        if pattern.contains("**") || pattern.contains("++") {
            factors.append(.nestedQuantifiers)
        }

        if pattern.count > 200 {
            factors.append(.veryLong)
        }

        return factors
    }

    /// Get optimization suggestions
    func getOptimizationSuggestions(_ pattern: String) -> [OptimizationSuggestion] {
        var suggestions: [OptimizationSuggestion] = []
        let score = calculateComplexity(pattern)

        if score.factors.contains(.manyAlternations) {
            suggestions.append(.considerCharacterClass)
        }

        if score.factors.contains(.manyGroups) {
            suggestions.append(.useNonCapturingGroups)
        }

        if score.factors.contains(.veryLong) {
            suggestions.append(.breakIntoMultiplePatterns)
        }

        if pattern.contains(".*") {
            suggestions.append(.useMoreSpecificPattern)
        }

        return suggestions
    }
}

// MARK: - Models

struct ComplexityScore {
    let score: Int
    let level: ComplexityLevel
    let factors: [ComplexityFactor]
}

enum ComplexityLevel: String {
    case simple = "Simple"
    case moderate = "Moderate"
    case complex = "Complex"
    case veryComplex = "Very Complex"

    var color: Color {
        switch self {
        case .simple:
            return .green
        case .moderate:
            return .yellow
        case .complex:
            return .orange
        case .veryComplex:
            return .red
        }
    }
}

enum ComplexityFactor: Hashable {
    case lookaround
    case manyAlternations
    case manyGroups
    case nestedQuantifiers
    case veryLong

    var description: String {
        switch self {
        case .lookaround:
            return "Uses lookahead/lookbehind"
        case .manyAlternations:
            return "Many alternations (|)"
        case .manyGroups:
            return "Many capture groups"
        case .nestedQuantifiers:
            return "Nested quantifiers"
        case .veryLong:
            return "Very long pattern"
        }
    }
}

enum OptimizationSuggestion {
    case considerCharacterClass
    case useNonCapturingGroups
    case breakIntoMultiplePatterns
    case useMoreSpecificPattern

    var description: String {
        switch self {
        case .considerCharacterClass:
            return "Consider using character classes instead of alternations"
        case .useNonCapturingGroups:
            return "Use non-capturing groups (?:...) when you don't need the capture"
        case .breakIntoMultiplePatterns:
            return "Consider breaking into multiple simpler patterns"
        case .useMoreSpecificPattern:
            return "Use more specific patterns instead of .*"
        }
    }
}

// Color reference is in the enum definition above
