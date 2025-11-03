//
//  RegexTesterViewModelTests.swift
//  PatternSorcererTests
//
//  Created on $(date)
//

import XCTest
import Combine
@testable import PatternSorcerer

@MainActor
final class RegexTesterViewModelTests: XCTestCase {
    var sut: RegexTesterViewModel!
    var mockEngine: MockRegexEngine!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockEngine = MockRegexEngine()
        cancellables = Set<AnyCancellable>()
        sut = RegexTesterViewModel(regexEngine: mockEngine)
    }

    override func tearDown() {
        cancellables.removeAll()
        sut = nil
        mockEngine = nil
        super.tearDown()
    }

    // MARK: - Pattern Validation Tests

    func testValidatePattern_ValidPattern_SetsIsValid() {
        // Given
        mockEngine.validationResult = (true, nil)
        sut.pattern = "hello"

        // When
        sut.validatePattern()

        // Then
        XCTAssertTrue(sut.isPatternValid)
        XCTAssertNil(sut.validationError)
    }

    func testValidatePattern_InvalidPattern_SetsIsInvalid() {
        // Given
        mockEngine.validationResult = (false, "Invalid pattern")
        sut.pattern = "[invalid"

        // When
        sut.validatePattern()

        // Then
        XCTAssertFalse(sut.isPatternValid)
        XCTAssertNotNil(sut.validationError)
    }

    // MARK: - Pattern Testing Tests

    func testTestPattern_ValidPattern_CallsRegexEngine() {
        // Given
        let expectedMatches = [
            MatchResult(range: NSRange(location: 0, length: 5), matchedText: "hello", captureGroups: [], matchNumber: 1)
        ]
        mockEngine.matchResult = expectedMatches
        sut.pattern = "hello"
        sut.testText = "hello world"
        sut.isPatternValid = true

        // When
        sut.testPattern()

        // Then
        XCTAssertEqual(sut.matches.count, 1)
        XCTAssertNotNil(sut.highlightedText, "Should create highlighted text")
    }

    func testTestPattern_InvalidPattern_DoesNotCallEngine() {
        // Given
        sut.pattern = "[invalid"
        sut.testText = "test"
        sut.isPatternValid = false

        // When
        sut.testPattern()

        // Then
        XCTAssertEqual(sut.matches.count, 0)
        XCTAssertNil(sut.highlightedText, "Should not highlight invalid pattern")
    }

    // MARK: - Clear Tests

    func testClearPattern_ClearsPatternAndMatches() {
        // Given
        sut.pattern = "test"
        sut.matches = [MatchResult(range: NSRange(), matchedText: "test", matchNumber: 1)]

        // When
        sut.clearPattern()

        // Then
        XCTAssertTrue(sut.pattern.isEmpty)
        XCTAssertTrue(sut.matches.isEmpty)
        XCTAssertNil(sut.validationError)
    }

    func testClearTestText_ClearsTestText() {
        // Given
        sut.testText = "test text"

        // When
        sut.clearTestText()

        // Then
        XCTAssertTrue(sut.testText.isEmpty)
    }
}

// Note: MockRegexEngine is now in Tests/Mocks/MockRegexEngine.swift

