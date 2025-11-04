//
//  PatternExplanationGeneratorTests.swift
//  PatternSorcererTests
//
//  Unit tests for PatternExplanationGenerator
//

import XCTest
@testable import PatternSorcerer

final class PatternExplanationGeneratorTests: XCTestCase {
    var sut: PatternExplanationGenerator!

    override func setUp() {
        super.setUp()
        sut = PatternExplanationGenerator()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Basic Pattern Tests

    func testExplain_SimplePattern_GeneratesExplanation() {
        // Given
        let pattern = "hello"

        // When
        let explanation = sut.explain(pattern)

        // Then
        XCTAssertEqual(explanation.pattern, pattern)
        XCTAssertFalse(explanation.parts.isEmpty)
        XCTAssertFalse(explanation.summary.isEmpty)
    }

    func testExplain_EmptyPattern_ReturnsEmptyExplanation() {
        // Given
        let pattern = ""

        // When
        let explanation = sut.explain(pattern)

        // Then
        XCTAssertEqual(explanation.pattern, pattern)
        XCTAssertTrue(explanation.parts.isEmpty)
        XCTAssertFalse(explanation.summary.isEmpty)
    }

    // MARK: - Anchor Tests

    func testExplain_StartAnchor_DetectsStartAnchor() {
        // Given
        let pattern = "^hello"

        // When
        let explanation = sut.explain(pattern)

        // Then
        let startAnchor = explanation.parts.first { $0.text == "^" }
        XCTAssertNotNil(startAnchor, "Should detect start anchor")
        XCTAssertTrue(startAnchor?.explanation.contains("start") ?? false)
    }

    func testExplain_EndAnchor_DetectsEndAnchor() {
        // Given
        let pattern = "hello$"

        // When
        let explanation = sut.explain(pattern)

        // Then
        let endAnchor = explanation.parts.first { $0.text == "$" }
        XCTAssertNotNil(endAnchor, "Should detect end anchor")
        XCTAssertTrue(endAnchor?.explanation.contains("end") ?? false)
    }

    // MARK: - Quantifier Tests

    func testExplain_StarQuantifier_DetectsStar() {
        // Given
        let pattern = "a*"

        // When
        let explanation = sut.explain(pattern)

        // Then
        let star = explanation.parts.first { $0.text == "*" }
        XCTAssertNotNil(star, "Should detect star quantifier")
        XCTAssertTrue(star?.explanation.contains("zero or more") ?? false)
    }

    func testExplain_PlusQuantifier_DetectsPlus() {
        // Given
        let pattern = "a+"

        // When
        let explanation = sut.explain(pattern)

        // Then
        let plus = explanation.parts.first { $0.text == "+" }
        XCTAssertNotNil(plus, "Should detect plus quantifier")
        XCTAssertTrue(plus?.explanation.contains("one or more") ?? false)
    }

    func testExplain_QuestionQuantifier_DetectsQuestion() {
        // Given
        let pattern = "a?"

        // When
        let explanation = sut.explain(pattern)

        // Then
        let question = explanation.parts.first { $0.text == "?" }
        XCTAssertNotNil(question, "Should detect question quantifier")
        XCTAssertTrue(question?.explanation.contains("zero or one") ?? false)
    }

    // MARK: - Capture Group Tests

    func testExplain_CaptureGroup_DetectsGroups() {
        // Given
        let pattern = "(hello)"

        // When
        let explanation = sut.explain(pattern)

        // Then
        let openParen = explanation.parts.first { $0.text == "(" }
        let closeParen = explanation.parts.first { $0.text == ")" }
        XCTAssertNotNil(openParen, "Should detect opening parenthesis")
        XCTAssertNotNil(closeParen, "Should detect closing parenthesis")
        XCTAssertTrue(openParen?.explanation.contains("capture group") ?? false)
    }

    // MARK: - Character Class Tests

    func testExplain_CharacterClass_DetectsClass() {
        // Given
        let pattern = "[0-9]"

        // When
        let explanation = sut.explain(pattern)

        // Then
        let charClass = explanation.parts.first { $0.text == "[0-9]" }
        XCTAssertNotNil(charClass, "Should detect character class")
        XCTAssertTrue(charClass?.explanation.contains("character") ?? false)
    }

    // MARK: - Escaped Character Tests

    func testExplain_EscapedDigit_DetectsEscapedDigit() {
        // Given
        let pattern = "\\d"

        // When
        let explanation = sut.explain(pattern)

        // Then
        let escaped = explanation.parts.first { $0.text == "\\d" }
        XCTAssertNotNil(escaped, "Should detect escaped digit")
        XCTAssertTrue(escaped?.explanation.contains("digit") ?? false)
    }

    func testExplain_EscapedWord_DetectsEscapedWord() {
        // Given
        let pattern = "\\w"

        // When
        let explanation = sut.explain(pattern)

        // Then
        let escaped = explanation.parts.first { $0.text == "\\w" }
        XCTAssertNotNil(escaped, "Should detect escaped word")
        XCTAssertTrue(escaped?.explanation.contains("word") ?? false)
    }

    // MARK: - Summary Tests

    func testExplain_WithStartAnchor_SummaryIncludesStart() {
        // Given
        let pattern = "^hello"

        // When
        let explanation = sut.explain(pattern)

        // Then
        XCTAssertTrue(explanation.summary.contains("start"), "Summary should mention start anchor")
    }

    func testExplain_WithEndAnchor_SummaryIncludesEnd() {
        // Given
        let pattern = "hello$"

        // When
        let explanation = sut.explain(pattern)

        // Then
        XCTAssertTrue(explanation.summary.contains("end"), "Summary should mention end anchor")
    }

    func testExplain_WithCaptureGroups_SummaryIncludesGroups() {
        // Given
        let pattern = "(a)(b)(c)"

        // When
        let explanation = sut.explain(pattern)

        // Then
        XCTAssertTrue(explanation.summary.contains("capture") || explanation.summary.contains("group"),
                     "Summary should mention capture groups")
    }

    // MARK: - Complex Pattern Tests

    func testExplain_ComplexPattern_GeneratesAllParts() {
        // Given
        let pattern = "^[0-9]+(\\w*)"

        // When
        let explanation = sut.explain(pattern)

        // Then
        XCTAssertGreaterThan(explanation.parts.count, 3, "Should parse multiple parts")
        XCTAssertFalse(explanation.summary.isEmpty)
    }
}

