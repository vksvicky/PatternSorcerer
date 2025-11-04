//
//  PatternExplanationGenerator.swift
//  PatternSorcerer
//
//  Unique feature: Generates human-readable explanations of regex patterns
//
//  Created on 2025-11-04
//

import Foundation

/// Generates human-readable explanations of regex patterns
class PatternExplanationGenerator {

    /// Generate explanation for a pattern
    func explain(_ pattern: String) -> PatternExplanation {
        var parts: [ExplanationPart] = []
        var currentIndex = pattern.startIndex

        while currentIndex < pattern.endIndex {
            let char = pattern[currentIndex]
            let result = processCharacter(char, at: currentIndex, in: pattern)

            if let part = result.part {
                parts.append(part)
            }

            if let newIndex = result.nextIndex {
                currentIndex = newIndex
            } else {
                currentIndex = pattern.index(after: currentIndex)
            }
        }

        return PatternExplanation(
            pattern: pattern,
            parts: parts,
            summary: generateSummary(parts)
        )
    }

    // MARK: - Character Processing

    private struct ProcessingResult {
        let part: ExplanationPart?
        let nextIndex: String.Index?
    }

    private func processCharacter(_ char: Character, at index: String.Index, in pattern: String) -> ProcessingResult {
        switch char {
        case "^", "$", ".", "*", "+", "?", "|", ")":
            return processSimpleCharacter(char, at: index)
        case "(":
            return processParenthesis(at: index, in: pattern)
        case "[":
            return processCharacterClass(at: index, in: pattern)
        case "\\":
            return processEscapedCharacter(at: index, in: pattern)
        case "{":
            return processQuantifier(at: index, in: pattern)
        default:
            return ProcessingResult(
                part: ExplanationPart(text: String(char), explanation: "Literal character"),
                nextIndex: nil
            )
        }
    }

    private func processSimpleCharacter(_ char: Character, at index: String.Index) -> ProcessingResult {
        let explanations: [Character: String] = [
            "^": "start of line anchor",
            "$": "end of line anchor",
            ".": "Matches any character except newline",
            "*": "Matches zero or more of the preceding element",
            "+": "Matches one or more of the preceding element",
            "?": "Matches zero or one of the preceding element",
            "|": "Alternation: matches either the expression before or after",
            ")": "End of capture group"
        ]
        return ProcessingResult(
            part: ExplanationPart(text: String(char), explanation: explanations[char] ?? ""),
            nextIndex: nil
        )
    }

    private func processParenthesis(at index: String.Index, in pattern: String) -> ProcessingResult {
        if let nextChar = pattern.index(after: index, limitedBy: pattern.endIndex),
           pattern[nextChar] == "?" {
            // Lookahead/lookbehind
            let offset = pattern.distance(from: pattern.startIndex, to: index) + 2
            let lookahead = pattern.dropFirst(offset)
            if lookahead.hasPrefix("=") {
                return ProcessingResult(
                    part: ExplanationPart(text: "(?=", explanation: "Positive lookahead: matches if followed by..."),
                    nextIndex: nil
                )
            } else if lookahead.hasPrefix("<=") {
                return ProcessingResult(
                    part: ExplanationPart(text: "(?<=", explanation: "Positive lookbehind: matches if preceded by..."),
                    nextIndex: nil
                )
            }
        }
        return ProcessingResult(
            part: ExplanationPart(text: "(", explanation: "Start of capture group"),
            nextIndex: nil
        )
    }

    private func processCharacterClass(at index: String.Index, in pattern: String) -> ProcessingResult {
        guard let endIndex = pattern.range(of: "]", range: index..<pattern.endIndex)?.upperBound else {
            return ProcessingResult(part: nil, nextIndex: nil)
        }
        let charClass = String(pattern[index..<endIndex])
        return ProcessingResult(
            part: ExplanationPart(text: charClass, explanation: explainCharacterClass(charClass)),
            nextIndex: pattern.index(before: endIndex)
        )
    }

    private func processEscapedCharacter(at index: String.Index, in pattern: String) -> ProcessingResult {
        guard let nextIndex = pattern.index(after: index, limitedBy: pattern.endIndex) else {
            return ProcessingResult(part: nil, nextIndex: nil)
        }
        let escaped = pattern[nextIndex]
        return ProcessingResult(
            part: ExplanationPart(
                text: "\\\(escaped)",
                explanation: explainEscapedCharacter(escaped)
            ),
            nextIndex: nextIndex
        )
    }

    private func processQuantifier(at index: String.Index, in pattern: String) -> ProcessingResult {
        guard let endIndex = pattern.range(of: "}", range: index..<pattern.endIndex)?.upperBound else {
            return ProcessingResult(part: nil, nextIndex: nil)
        }
        let quantifier = String(pattern[index..<endIndex])
        return ProcessingResult(
            part: ExplanationPart(text: quantifier, explanation: explainQuantifier(quantifier)),
            nextIndex: pattern.index(before: endIndex)
        )
    }

    // MARK: - Explanation Helpers

    private func explainCharacterClass(_ charClass: String) -> String {
        if charClass == "[0-9]" || charClass == "\\d" {
            return "digit character (0-9)"
        } else if charClass == "[a-zA-Z]" || charClass == "\\w" {
            return "word character (letter, digit, underscore)"
        } else if charClass == "\\s" {
            return "whitespace character"
        } else {
            return "character class: any character in the set"
        }
    }

    private func explainEscapedCharacter(_ char: Character) -> String {
        switch char {
        case "d":
            return "Matches any digit (0-9)"
        case "w":
            return "Matches any word character"
        case "s":
            return "Matches any whitespace character"
        case "n":
            return "Matches newline character"
        case "t":
            return "Matches tab character"
        case "b":
            return "Word boundary"
        default:
            return "Escaped character"
        }
    }

    private func explainQuantifier(_ quantifier: String) -> String {
        if quantifier.contains(",") {
            let parts = quantifier.trimmingCharacters(in: CharacterSet(charactersIn: "{}")).split(separator: ",")
            if parts.count == 2 {
                return "Matches between \(parts[0]) and \(parts[1]) times"
            } else {
                return "Matches at least \(parts[0]) times"
            }
        } else {
            let count = quantifier.trimmingCharacters(in: CharacterSet(charactersIn: "{}"))
            return "Matches exactly \(count) times"
        }
    }

    private func generateSummary(_ parts: [ExplanationPart]) -> String {
        var summary = "This pattern"

        if parts.contains(where: { $0.text == "^" }) {
            summary += " matches from the start of the line"
        }

        let captureGroups = parts.filter { $0.text == "(" }.count
        if captureGroups > 0 {
            summary += ", captures \(captureGroups) group\(captureGroups == 1 ? "" : "s")"
        }

        if parts.contains(where: { $0.text == "$" }) {
            summary += ", and matches to the end of the line"
        }

        return summary + "."
    }
}

// MARK: - Models

struct PatternExplanation {
    let pattern: String
    let parts: [ExplanationPart]
    let summary: String
}

struct ExplanationPart {
    let text: String
    let explanation: String
}

// Helper extension
extension String {
    func index(after i: Index, limitedBy limit: Index) -> Index? {
        let next = index(after: i)
        return next < limit ? next : nil
    }
}
