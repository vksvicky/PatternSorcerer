//
//  RegexTesterBDDTests.swift
//  PatternSorcererTests
//
//  BDD-style tests using Gherkin-like structure
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class RegexTesterBDDTests: XCTestCase {
    var sut: RegexTesterViewModel!
    var mockEngine: MockRegexEngine!

    override func setUp() {
        super.setUp()
        mockEngine = MockRegexEngine()
        sut = RegexTesterViewModel(regexEngine: mockEngine)
    }

    override func tearDown() {
        sut = nil
        mockEngine = nil
        super.tearDown()
    }

    // MARK: - Feature: Pattern Validation

    func testFeature_PatternValidation_ValidPattern() {
        // Given: the user enters a valid regex pattern
        let pattern = "hello"
        mockEngine.validationResult = (true, nil)

        // When: the pattern is validated
        sut.pattern = pattern
        sut.validatePattern()

        // Then: the pattern should be marked as valid
        XCTAssertTrue(sut.isPatternValid, "Pattern should be valid")
        XCTAssertNil(sut.validationError, "No error should be present")
    }

    func testFeature_PatternValidation_InvalidPattern() {
        // Given: the user enters an invalid regex pattern
        let pattern = "[invalid"
        mockEngine.validationResult = (false, "The value \"[invalid\" is invalid.")

        // When: the pattern is validated
        sut.pattern = pattern
        sut.validatePattern()

        // Then: the pattern should be marked as invalid with an error message
        XCTAssertFalse(sut.isPatternValid, "Pattern should be invalid")
        XCTAssertNotNil(sut.validationError, "Error message should be present")
    }

    // MARK: - Feature: Pattern Matching

    func testFeature_PatternMatching_SingleMatch() {
        // Given: a valid pattern and test text with one match
        let match = MatchResult(
            range: NSRange(location: 0, length: 5),
            matchedText: "hello",
            matchNumber: 1
        )
        mockEngine.matchResult = [match]
        sut.pattern = "hello"
        sut.testText = "hello world"
        sut.isPatternValid = true

        // When: the pattern is tested
        sut.testPattern()

        // Then: one match should be found
        XCTAssertEqual(sut.matches.count, 1, "Should find one match")
        XCTAssertEqual(sut.matches.first?.matchedText, "hello", "Match text should be 'hello'")
        XCTAssertNotNil(sut.highlightedText, "Should create highlighted text")
    }

    func testFeature_PatternMatching_MultipleMatches() {
        // Given: a valid pattern and test text with multiple matches
        let match1 = MatchResult(
            range: NSRange(location: 0, length: 5),
            matchedText: "hello",
            matchNumber: 1
        )
        let match2 = MatchResult(
            range: NSRange(location: 12, length: 5),
            matchedText: "hello",
            matchNumber: 2
        )
        mockEngine.matchResult = [match1, match2]
        sut.pattern = "hello"
        sut.testText = "hello world hello"
        sut.isPatternValid = true

        // When: the pattern is tested
        sut.testPattern()

        // Then: multiple matches should be found
        XCTAssertEqual(sut.matches.count, 2, "Should find two matches")
        XCTAssertEqual(sut.highlightedText?.highlights.count, 2, "Should highlight both matches")
    }

    func testFeature_PatternMatching_CaptureGroups() {
        // Given: a pattern with capture groups and matching text
        let group1 = CaptureGroup(
            index: 1,
            range: NSRange(location: 0, length: 3),
            text: "123"
        )
        let group2 = CaptureGroup(
            index: 2,
            range: NSRange(location: 4, length: 3),
            text: "456"
        )
        let match = MatchResult(
            range: NSRange(location: 0, length: 7),
            matchedText: "123-456",
            captureGroups: [group1, group2],
            matchNumber: 1
        )
        mockEngine.matchResult = [match]
        sut.pattern = "(\\d+)-(\\d+)"
        sut.testText = "123-456"
        sut.isPatternValid = true

        // When: the pattern is tested
        sut.testPattern()

        // Then: capture groups should be extracted
        XCTAssertEqual(sut.matches.count, 1, "Should find one match")
        guard let resultMatch = sut.matches.first else {
            XCTFail("Expected one match")
            return
        }
        XCTAssertEqual(resultMatch.captureGroups.count, 2, "Should have two capture groups")
        XCTAssertEqual(resultMatch.captureGroups[0].text, "123", "First group should be '123'")
        XCTAssertEqual(resultMatch.captureGroups[1].text, "456", "Second group should be '456'")
        // Should have 1 match highlight + 2 group highlights = 3 total
        XCTAssertEqual(sut.highlightedText?.highlights.count, 3, "Should highlight match and groups")
    }

    // MARK: - Feature: Pattern Clearing

    func testFeature_PatternClearing_ClearsPatternAndMatches() {
        // Given: a pattern with matches
        let match = MatchResult(
            range: NSRange(location: 0, length: 5),
            matchedText: "hello",
            matchNumber: 1
        )
        mockEngine.matchResult = [match]
        mockEngine.validationResult = (true, nil)
        sut.pattern = "hello"
        sut.testText = "hello world"
        sut.isPatternValid = true
        sut.testPattern()
        XCTAssertFalse(sut.matches.isEmpty, "Should have matches before clearing")

        // When: the pattern is cleared
        sut.clearPattern()

        // Then: pattern and matches should be cleared
        XCTAssertTrue(sut.pattern.isEmpty, "Pattern should be empty")
        XCTAssertTrue(sut.matches.isEmpty, "Matches should be empty")
        XCTAssertNil(sut.validationError, "Error should be nil")
    }
}
