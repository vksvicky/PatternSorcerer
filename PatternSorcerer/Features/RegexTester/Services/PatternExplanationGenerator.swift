//
//  PatternExplanationGenerator.swift
//  PatternSorcerer
//
//  Unique feature: Generates human-readable explanations of regex patterns
//
//  Created on $(date)
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
            
            switch char {
            case "^":
                parts.append(ExplanationPart(
                    text: "^",
                    explanation: "Start of line anchor"
                ))
                
            case "$":
                parts.append(ExplanationPart(
                    text: "$",
                    explanation: "End of line anchor"
                ))
                
            case ".":
                parts.append(ExplanationPart(
                    text: ".",
                    explanation: "Matches any character except newline"
                ))
                
            case "*":
                parts.append(ExplanationPart(
                    text: "*",
                    explanation: "Matches zero or more of the preceding element"
                ))
                
            case "+":
                parts.append(ExplanationPart(
                    text: "+",
                    explanation: "Matches one or more of the preceding element"
                ))
                
            case "?":
                parts.append(ExplanationPart(
                    text: "?",
                    explanation: "Matches zero or one of the preceding element"
                ))
                
            case "|":
                parts.append(ExplanationPart(
                    text: "|",
                    explanation: "Alternation: matches either the expression before or after"
                ))
                
            case "(":
                if let nextChar = pattern.index(after: currentIndex, limitedBy: pattern.endIndex),
                   pattern[nextChar] == "?" {
                    // Lookahead/lookbehind
                    let lookahead = pattern.dropFirst(pattern.distance(from: pattern.startIndex, to: currentIndex) + 2)
                    if lookahead.hasPrefix("=") {
                        parts.append(ExplanationPart(
                            text: "(?=",
                            explanation: "Positive lookahead: matches if followed by..."
                        ))
                    } else if lookahead.hasPrefix("<=") {
                        parts.append(ExplanationPart(
                            text: "(?<=",
                            explanation: "Positive lookbehind: matches if preceded by..."
                        ))
                    }
                } else {
                    parts.append(ExplanationPart(
                        text: "(",
                        explanation: "Start of capture group"
                    ))
                }
                
            case ")":
                parts.append(ExplanationPart(
                    text: ")",
                    explanation: "End of capture group"
                ))
                
            case "[":
                if let endIndex = pattern.range(of: "]", range: currentIndex..<pattern.endIndex)?.upperBound {
                    let charClass = String(pattern[currentIndex..<endIndex])
                    parts.append(ExplanationPart(
                        text: charClass,
                        explanation: explainCharacterClass(charClass)
                    ))
                    currentIndex = pattern.index(before: endIndex)
                }
                
            case "\\":
                if let nextIndex = pattern.index(after: currentIndex, limitedBy: pattern.endIndex) {
                    let escaped = pattern[nextIndex]
                    parts.append(ExplanationPart(
                        text: "\\\(escaped)",
                        explanation: explainEscapedCharacter(escaped)
                    ))
                    currentIndex = nextIndex
                }
                
            case "{":
                if let endIndex = pattern.range(of: "}", range: currentIndex..<pattern.endIndex)?.upperBound {
                    let quantifier = String(pattern[currentIndex..<endIndex])
                    parts.append(ExplanationPart(
                        text: quantifier,
                        explanation: explainQuantifier(quantifier)
                    ))
                    currentIndex = pattern.index(before: endIndex)
                }
                
            default:
                parts.append(ExplanationPart(
                    text: String(char),
                    explanation: "Literal character"
                ))
            }
            
            currentIndex = pattern.index(after: currentIndex)
        }
        
        return PatternExplanation(
            pattern: pattern,
            parts: parts,
            summary: generateSummary(parts)
        )
    }
    
    private func explainCharacterClass(_ charClass: String) -> String {
        if charClass == "[0-9]" || charClass == "\\d" {
            return "Matches any digit (0-9)"
        } else if charClass == "[a-zA-Z]" || charClass == "\\w" {
            return "Matches any word character (letter, digit, underscore)"
        } else if charClass == "\\s" {
            return "Matches any whitespace character"
        } else {
            return "Character class: matches any character in the set"
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

