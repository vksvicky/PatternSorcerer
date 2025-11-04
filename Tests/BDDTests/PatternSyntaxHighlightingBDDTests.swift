//
//  PatternSyntaxHighlightingBDDTests.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class PatternSyntaxHighlightingBDDTests: XCTestCase {
    var sut: PatternSyntaxHighlighter!
    var mockHighlighter: MockPatternSyntaxHighlighter!

    override func setUp() {
        super.setUp()
        mockHighlighter = MockPatternSyntaxHighlighter()
        sut = PatternSyntaxHighlighter()
    }

    override func tearDown() {
        sut = nil
        mockHighlighter = nil
        super.tearDown()
    }

    // MARK: - Feature: Pattern Syntax Highlighting

    func testFeature_HighlightPattern_CharacterClasses_ColorsCorrectly() {
        // Given: a pattern with character classes
        let pattern = "\\d+\\w*"

        // When: the pattern is highlighted
        let tokens = sut.highlight(pattern: pattern)

        // Then: character classes should be identified and colored
        let digitToken = tokens.first { $0.text == "\\d" && $0.type == .characterClass }
        let wordToken = tokens.first { $0.text == "\\w" && $0.type == .characterClass }
        XCTAssertNotNil(digitToken, "Should highlight \\d as character class")
        XCTAssertNotNil(wordToken, "Should highlight \\w as character class")
    }

    func testFeature_HighlightPattern_Quantifiers_ColorsCorrectly() {
        // Given: a pattern with quantifiers
        let pattern = "a+b*c?"

        // When: the pattern is highlighted
        let tokens = sut.highlight(pattern: pattern)

        // Then: quantifiers should be identified and colored
        let plusToken = tokens.first { $0.text == "+" && $0.type == .quantifier }
        let starToken = tokens.first { $0.text == "*" && $0.type == .quantifier }
        let questionToken = tokens.first { $0.text == "?" && $0.type == .quantifier }
        XCTAssertNotNil(plusToken, "Should highlight + as quantifier")
        XCTAssertNotNil(starToken, "Should highlight * as quantifier")
        XCTAssertNotNil(questionToken, "Should highlight ? as quantifier")
    }

    func testFeature_HighlightPattern_CaptureGroups_ColorsCorrectly() {
        // Given: a pattern with capture groups
        let pattern = "(abc)(def)"

        // When: the pattern is highlighted
        let tokens = sut.highlight(pattern: pattern)

        // Then: capture groups should be identified
        let openParens = tokens.filter { $0.text == "(" && $0.type == .captureGroup }
        XCTAssertEqual(openParens.count, 2, "Should identify both opening parentheses as capture groups")
    }

    func testFeature_HighlightPattern_Anchors_ColorsCorrectly() {
        // Given: a pattern with anchors
        let pattern = "^start.*end$"

        // When: the pattern is highlighted
        let tokens = sut.highlight(pattern: pattern)

        // Then: anchors should be identified
        let startAnchor = tokens.first { $0.text == "^" && $0.type == .anchor }
        let endAnchor = tokens.first { $0.text == "$" && $0.type == .anchor }
        XCTAssertNotNil(startAnchor, "Should highlight ^ as anchor")
        XCTAssertNotNil(endAnchor, "Should highlight $ as anchor")
    }

    func testFeature_HighlightPattern_EscapeSequences_ColorsCorrectly() {
        // Given: a pattern with escape sequences
        let pattern = "\\n\\t\\r"

        // When: the pattern is highlighted
        let tokens = sut.highlight(pattern: pattern)

        // Then: escape sequences should be identified
        let newlineToken = tokens.first { $0.text == "\\n" && $0.type == .escapeSequence }
        let tabToken = tokens.first { $0.text == "\\t" && $0.type == .escapeSequence }
        XCTAssertNotNil(newlineToken, "Should highlight \\n as escape sequence")
        XCTAssertNotNil(tabToken, "Should highlight \\t as escape sequence")
    }

    func testFeature_HighlightPattern_Alternation_ColorsCorrectly() {
        // Given: a pattern with alternation
        let pattern = "a|b|c"

        // When: the pattern is highlighted
        let tokens = sut.highlight(pattern: pattern)

        // Then: alternation operators should be identified
        let alternationTokens = tokens.filter { $0.text == "|" && $0.type == .alternation }
        XCTAssertEqual(alternationTokens.count, 2, "Should identify both | as alternation")
    }

    func testFeature_HighlightPattern_CharacterSets_ColorsCorrectly() {
        // Given: a pattern with character sets
        let pattern = "[abc][^0-9]"

        // When: the pattern is highlighted
        let tokens = sut.highlight(pattern: pattern)

        // Then: character sets should be identified
        let charSetTokens = tokens.filter { $0.type == .characterSet }
        XCTAssertGreaterThan(charSetTokens.count, 0, "Should identify character sets")
    }

    func testFeature_HighlightPattern_EmptyPattern_ReturnsEmptyTokens() {
        // Given: an empty pattern
        let pattern = ""

        // When: the pattern is highlighted
        let tokens = sut.highlight(pattern: pattern)

        // Then: should return empty tokens
        XCTAssertTrue(tokens.isEmpty, "Should return empty tokens for empty pattern")
    }

    func testFeature_HighlightPattern_InvalidPattern_StillHighlightsValidParts() {
        // Given: a pattern with invalid syntax
        let pattern = "\\d+[unclosed"

        // When: the pattern is highlighted
        let tokens = sut.highlight(pattern: pattern)

        // Then: valid parts should still be highlighted
        let digitToken = tokens.first { $0.text == "\\d" && $0.type == .characterClass }
        let quantifierToken = tokens.first { $0.text == "+" && $0.type == .quantifier }
        XCTAssertNotNil(digitToken, "Should highlight valid \\d even with invalid syntax")
        XCTAssertNotNil(quantifierToken, "Should highlight valid + even with invalid syntax")
    }
}
