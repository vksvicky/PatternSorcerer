//
//  MatchHighlightingBDDTests.swift
//  PatternSorcererTests
//
//  BDD-style tests for match highlighting feature
//

import XCTest
import SwiftUI
@testable import PatternSorcerer

@MainActor
final class MatchHighlightingBDDTests: XCTestCase {
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

    // MARK: - Feature: Match Highlighting

    func testFeature_MatchHighlighting_SingleMatch_HighlightsMatch() {
        // Given: a pattern with one match in the test text
        sut.pattern = "hello"
        sut.testText = "hello world"
        sut.isPatternValid = true

        let match = MatchResult(
            range: NSRange(location: 0, length: 5),
            matchedText: "hello",
            matchNumber: 1
        )
        mockEngine.matchResult = [match]

        // When: the pattern is tested
        sut.testPattern()

        // Then: the match should be highlighted
        XCTAssertNotNil(sut.highlightedText, "Highlighted text should be created")
        XCTAssertEqual(sut.highlightedText?.highlights.count, 1, "Should have one highlight")
        XCTAssertEqual(sut.highlightedText?.highlights.first?.range, NSRange(location: 0, length: 5), "Highlight should cover match range")

        if case .match(let number) = sut.highlightedText?.highlights.first?.type {
            XCTAssertEqual(number, 1, "Match number should be 1")
        } else {
            XCTFail("Highlight type should be match")
        }
    }

    func testFeature_MatchHighlighting_MultipleMatches_HighlightsAllMatches() {
        // Given: a pattern with multiple matches
        sut.pattern = "hello"
        sut.testText = "hello world hello"
        sut.isPatternValid = true

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

        // When: the pattern is tested
        sut.testPattern()

        // Then: all matches should be highlighted
        XCTAssertNotNil(sut.highlightedText, "Highlighted text should be created")
        XCTAssertEqual(sut.highlightedText?.highlights.count, 2, "Should have two highlights")

        let highlights = sut.highlightedText?.highlights ?? []
        XCTAssertEqual(highlights[0].range, NSRange(location: 0, length: 5), "First highlight should be at start")
        XCTAssertEqual(highlights[1].range, NSRange(location: 12, length: 5), "Second highlight should be at position 12")
    }

    func testFeature_MatchHighlighting_CaptureGroups_HighlightsGroups() {
        // Given: a pattern with capture groups
        sut.pattern = "(\\d+)-(\\d+)"
        sut.testText = "123-456"
        sut.isPatternValid = true

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

        // When: the pattern is tested
        sut.testPattern()

        // Then: match and capture groups should be highlighted
        XCTAssertNotNil(sut.highlightedText, "Highlighted text should be created")
        // Should have 1 match highlight + 2 capture group highlights = 3 total
        XCTAssertEqual(sut.highlightedText?.highlights.count, 3, "Should have match and group highlights")

        let highlights = sut.highlightedText?.highlights ?? []
        let hasMatchHighlight = highlights.contains { highlight in
            if case .match = highlight.type {
                return true
            }
            return false
        }
        XCTAssertTrue(hasMatchHighlight, "Should have match highlight")

        let hasGroupHighlights = highlights.filter { highlight in
            if case .captureGroup = highlight.type {
                return true
            }
            return false
        }
        XCTAssertEqual(hasGroupHighlights.count, 2, "Should have two capture group highlights")
    }

    func testFeature_MatchHighlighting_NoMatches_NoHighlighting() {
        // Given: a pattern with no matches
        sut.pattern = "xyz"
        sut.testText = "hello world"
        sut.isPatternValid = true

        mockEngine.matchResult = []

        // When: the pattern is tested
        sut.testPattern()

        // Then: no highlighting should be created
        XCTAssertNotNil(sut.highlightedText, "Highlighted text should exist")
        XCTAssertEqual(sut.highlightedText?.highlights.count, 0, "Should have no highlights")
    }

    func testFeature_MatchHighlighting_InvalidPattern_NoHighlighting() {
        // Given: an invalid pattern
        sut.pattern = "[invalid"
        sut.testText = "hello world"
        sut.isPatternValid = false

        // When: attempting to test pattern
        sut.testPattern()

        // Then: no highlighting should be created
        XCTAssertNil(sut.highlightedText, "Should not highlight invalid pattern")
    }

    func testFeature_MatchHighlighting_EmptyText_NoHighlighting() {
        // Given: empty test text
        sut.pattern = "hello"
        sut.testText = ""
        sut.isPatternValid = true

        // When: attempting to test pattern
        sut.testPattern()

        // Then: no highlighting should be created
        XCTAssertNil(sut.highlightedText, "Should not highlight empty text")
    }
}

