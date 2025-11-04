//
//  PatternSyntaxHighlighter.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Service for highlighting regex pattern syntax
final class PatternSyntaxHighlighter: PatternSyntaxHighlighterProtocol {
    // MARK: - PatternSyntaxHighlighterProtocol

    func highlight(pattern: String) -> [SyntaxToken] {
        guard !pattern.isEmpty else {
            return []
        }

        var tokens: [SyntaxToken] = []
        var currentIndex = pattern.startIndex
        var tokenStartIndex = currentIndex

        while currentIndex < pattern.endIndex {
            let char = pattern[currentIndex]

            if let result = processEscapeSequence(
                at: currentIndex,
                tokenStart: tokenStartIndex,
                in: pattern
            ) {
                appendTokenIfNeeded(&tokens, from: tokenStartIndex, to: currentIndex, in: pattern)
                tokens.append(result.token)
                currentIndex = result.processedIndex
                tokenStartIndex = currentIndex
                continue
            }

            if let result = processSpecialCharacter(
                char,
                at: currentIndex,
                tokenStart: tokenStartIndex,
                in: pattern
            ) {
                appendTokenIfNeeded(&tokens, from: tokenStartIndex, to: currentIndex, in: pattern)
                tokens.append(result.token)
                currentIndex = result.processedIndex
                tokenStartIndex = currentIndex
                continue
            }

            currentIndex = pattern.index(after: currentIndex)
        }

        appendTokenIfNeeded(&tokens, from: tokenStartIndex, to: pattern.endIndex, in: pattern)

        return tokens
    }

    private func appendTokenIfNeeded(
        _ tokens: inout [SyntaxToken],
        from startIndex: String.Index,
        to endIndex: String.Index,
        in pattern: String
    ) {
        if let literalToken = createLiteralToken(from: startIndex, to: endIndex, in: pattern) {
            tokens.append(literalToken)
        }
    }

    // MARK: - Helper Methods

    private func createLiteralToken(
        from startIndex: String.Index,
        to endIndex: String.Index,
        in pattern: String
    ) -> SyntaxToken? {
        guard startIndex < endIndex else {
            return nil
        }
        let literalText = String(pattern[startIndex..<endIndex])
        guard !literalText.isEmpty else {
            return nil
        }
        let range = NSRange(
            location: pattern.distance(from: pattern.startIndex, to: startIndex),
            length: pattern.distance(from: startIndex, to: endIndex)
        )
        return SyntaxToken(text: literalText, type: .literal, range: range)
    }

    private func processEscapeSequence(
        at index: String.Index,
        tokenStart: String.Index,
        in pattern: String
    ) -> (processedIndex: String.Index, token: SyntaxToken)? {
        guard pattern[index] == "\\",
              index < pattern.index(before: pattern.endIndex) else {
            return nil
        }

        let nextIndex = pattern.index(after: index)
        let nextChar = pattern[nextIndex]

        // Character classes: \d, \D, \w, \W, \s, \S
        if ["d", "D", "w", "W", "s", "S"].contains(nextChar) {
            let tokenText = String(pattern[tokenStart...nextIndex])
            let range = NSRange(
                location: pattern.distance(from: pattern.startIndex, to: tokenStart),
                length: pattern.distance(from: tokenStart, to: nextIndex) + 1
            )
            let token = SyntaxToken(text: tokenText, type: .characterClass, range: range)
            return (pattern.index(after: nextIndex), token)
        }

        // Escape sequences
        if ["n", "t", "r", "\\", ".", "*", "+", "?", "|", "(", ")", "[", "]", "{", "}", "^", "$"].contains(nextChar) {
            let tokenText = String(pattern[tokenStart...nextIndex])
            let range = NSRange(
                location: pattern.distance(from: pattern.startIndex, to: tokenStart),
                length: pattern.distance(from: tokenStart, to: nextIndex) + 1
            )
            let token = SyntaxToken(text: tokenText, type: .escapeSequence, range: range)
            return (pattern.index(after: nextIndex), token)
        }

        return nil
    }

    private func processSpecialCharacter(
        _ char: Character,
        at index: String.Index,
        tokenStart: String.Index,
        in pattern: String
    ) -> (processedIndex: String.Index, token: SyntaxToken)? {
        // Anchors
        if char == "^" || char == "$" {
            let range = NSRange(
                location: pattern.distance(from: pattern.startIndex, to: index),
                length: 1
            )
            let token = SyntaxToken(text: String(char), type: .anchor, range: range)
            return (pattern.index(after: index), token)
        }

        // Quantifiers
        if ["*", "+", "?", "{"].contains(char) {
            return processQuantifier(at: index, char: char, in: pattern)
        }

        // Capture groups
        if char == "(" || char == ")" {
            let range = NSRange(
                location: pattern.distance(from: pattern.startIndex, to: index),
                length: 1
            )
            let token = SyntaxToken(text: String(char), type: .captureGroup, range: range)
            return (pattern.index(after: index), token)
        }

        // Alternation
        if char == "|" {
            let range = NSRange(
                location: pattern.distance(from: pattern.startIndex, to: index),
                length: 1
            )
            let token = SyntaxToken(text: "|", type: .alternation, range: range)
            return (pattern.index(after: index), token)
        }

        // Character sets
        if char == "[" {
            return processCharacterSet(at: index, in: pattern)
        }

        return nil
    }

    private func processQuantifier(
        at index: String.Index,
        char: Character,
        in pattern: String
    ) -> (processedIndex: String.Index, token: SyntaxToken)? {
        var quantifierText = String(char)
        var quantifierEnd = pattern.index(after: index)

        // Handle {n}, {n,}, {n,m}
        if char == "{" {
            while quantifierEnd < pattern.endIndex && pattern[quantifierEnd] != "}" {
                quantifierText.append(pattern[quantifierEnd])
                quantifierEnd = pattern.index(after: quantifierEnd)
            }
            if quantifierEnd < pattern.endIndex {
                quantifierText.append(pattern[quantifierEnd])
                quantifierEnd = pattern.index(after: quantifierEnd)
            }
        }

        let range = NSRange(
            location: pattern.distance(from: pattern.startIndex, to: index),
            length: pattern.distance(from: index, to: quantifierEnd)
        )
        let token = SyntaxToken(text: quantifierText, type: .quantifier, range: range)
        return (quantifierEnd, token)
    }

    private func processCharacterSet(
        at index: String.Index,
        in pattern: String
    ) -> (processedIndex: String.Index, token: SyntaxToken)? {
        var charSetText = String(pattern[index])
        var charSetEnd = pattern.index(after: index)
        var escaped = false

        while charSetEnd < pattern.endIndex {
            let charSetChar = pattern[charSetEnd]
            if escaped {
                charSetText.append(charSetChar)
                escaped = false
                charSetEnd = pattern.index(after: charSetEnd)
            } else if charSetChar == "\\" {
                charSetText.append(charSetChar)
                escaped = true
                charSetEnd = pattern.index(after: charSetEnd)
            } else if charSetChar == "]" {
                charSetText.append(charSetChar)
                charSetEnd = pattern.index(after: charSetEnd)
                break
            } else {
                charSetText.append(charSetChar)
                charSetEnd = pattern.index(after: charSetEnd)
            }
        }

        let range = NSRange(
            location: pattern.distance(from: pattern.startIndex, to: index),
            length: pattern.distance(from: index, to: charSetEnd)
        )
        let token = SyntaxToken(text: charSetText, type: .characterSet, range: range)
        return (charSetEnd, token)
    }
}
