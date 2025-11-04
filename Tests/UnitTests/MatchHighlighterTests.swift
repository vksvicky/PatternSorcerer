//
//  MatchHighlighterTests.swift
//  PatternSorcererTests
//
//  Unit tests for MatchHighlighter service
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import SwiftUI
import XCTest

final class MatchHighlighterTests: XCTestCase {
    var sut: MatchHighlighter!

    override func setUp() {
        super.setUp()
        sut = MatchHighlighter()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Highlight Creation Tests

    func testHighlight_SingleMatch_CreatesHighlight() {
        // Given
        let text = "hello world"
        let match = MatchResult(
            range: NSRange(location: 0, length: 5),
            matchedText: "hello",
            matchNumber: 1
        )

        // When
        let result = sut.highlight(text: text, matches: [match])

        // Then
        XCTAssertEqual(result.text, text)
        XCTAssertEqual(result.highlights.count, 1)
        XCTAssertEqual(result.highlights.first?.range, NSRange(location: 0, length: 5))

        if case .match(let number) = result.highlights.first?.type {
            XCTAssertEqual(number, 1)
        } else {
            XCTFail("Should be match type")
        }
    }

    func testHighlight_MultipleMatches_CreatesMultipleHighlights() {
        // Given
        let text = "hello world hello"
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

        // When
        let result = sut.highlight(text: text, matches: [match1, match2])

        // Then
        XCTAssertEqual(result.highlights.count, 2)
        XCTAssertEqual(result.highlights[0].range.location, 0)
        XCTAssertEqual(result.highlights[1].range.location, 12)
    }

    func testHighlight_CaptureGroups_CreatesGroupHighlights() {
        // Given
        let text = "123-456"
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

        // When
        let result = sut.highlight(text: text, matches: [match])

        // Then
        // 1 match + 2 groups = 3 highlights
        XCTAssertEqual(result.highlights.count, 3)

        let matchHighlights = result.highlights.filter { highlight in
            if case .match = highlight.type {
                return true
            }
            return false
        }
        XCTAssertEqual(matchHighlights.count, 1, "Should have one match highlight")

        let groupHighlights = result.highlights.filter { highlight in
            if case .captureGroup = highlight.type {
                return true
            }
            return false
        }
        XCTAssertEqual(groupHighlights.count, 2, "Should have two group highlights")
    }

    func testHighlight_NoMatches_ReturnsEmptyHighlights() {
        // Given
        let text = "hello world"

        // When
        let result = sut.highlight(text: text, matches: [])

        // Then
        XCTAssertEqual(result.text, text)
        XCTAssertEqual(result.highlights.count, 0)
    }

    func testHighlight_DisableMatches_OnlyGroupsHighlighted() {
        // Given
        let text = "123-456"
        let group1 = CaptureGroup(
            index: 1,
            range: NSRange(location: 0, length: 3),
            text: "123"
        )
        let match = MatchResult(
            range: NSRange(location: 0, length: 7),
            matchedText: "123-456",
            captureGroups: [group1],
            matchNumber: 1
        )

        // When
        let result = sut.highlight(
            text: text,
            matches: [match],
            highlightMatches: false,
            highlightCaptureGroups: true
        )

        // Then
        // Only group highlight, no match highlight
        XCTAssertEqual(result.highlights.count, 1)
        if case .captureGroup = result.highlights.first?.type {
            // Expected
        } else {
            XCTFail("Should only have capture group highlight")
        }
    }

    func testHighlight_DisableGroups_OnlyMatchesHighlighted() {
        // Given
        let text = "123-456"
        let group1 = CaptureGroup(
            index: 1,
            range: NSRange(location: 0, length: 3),
            text: "123"
        )
        let match = MatchResult(
            range: NSRange(location: 0, length: 7),
            matchedText: "123-456",
            captureGroups: [group1],
            matchNumber: 1
        )

        // When
        let result = sut.highlight(
            text: text,
            matches: [match],
            highlightMatches: true,
            highlightCaptureGroups: false
        )

        // Then
        // Only match highlight, no group highlights
        XCTAssertEqual(result.highlights.count, 1)
        if case .match = result.highlights.first?.type {
            // Expected
        } else {
            XCTFail("Should only have match highlight")
        }
    }

    func testHighlight_HighlightsSortedByPosition() {
        // Given: matches in reverse order
        let text = "hello world test"
        let match2 = MatchResult(
            range: NSRange(location: 12, length: 4),
            matchedText: "test",
            matchNumber: 2
        )
        let match1 = MatchResult(
            range: NSRange(location: 0, length: 5),
            matchedText: "hello",
            matchNumber: 1
        )

        // When
        let result = sut.highlight(text: text, matches: [match2, match1])

        // Then: highlights should be sorted by position
        XCTAssertEqual(result.highlights[0].range.location, 0)
        XCTAssertEqual(result.highlights[1].range.location, 12)
    }
}
