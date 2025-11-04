//
//  SplitToolBDDTests.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class SplitToolBDDTests: XCTestCase {
    var sut: SplitToolViewModel!
    var mockRegexEngine: MockRegexEngine!

    override func setUp() {
        super.setUp()
        mockRegexEngine = MockRegexEngine()
        sut = SplitToolViewModel(regexEngine: mockRegexEngine)
    }

    override func tearDown() {
        sut = nil
        mockRegexEngine = nil
        super.tearDown()
    }

    // MARK: - Feature: Split Text with Regex

    func testFeature_SplitText_WithPattern_SplitsText() {
        // Given: a pattern and text to split
        sut.pattern = ","
        sut.inputText = "apple,banana,orange"
        mockRegexEngine.splitResult = ["apple", "banana", "orange"]

        // When: the user performs split
        sut.performSplit()

        // Then: the text should be split into parts
        XCTAssertEqual(sut.outputParts.count, 3, "Should split into 3 parts")
        XCTAssertEqual(sut.outputParts[0], "apple", "First part should be apple")
        XCTAssertEqual(sut.outputParts[1], "banana", "Second part should be banana")
        XCTAssertEqual(sut.outputParts[2], "orange", "Third part should be orange")
    }

    func testFeature_SplitText_WithWhitespacePattern_SplitsByWhitespace() {
        // Given: a whitespace pattern
        sut.pattern = "\\s+"
        sut.inputText = "hello   world    test"
        mockRegexEngine.splitResult = ["hello", "world", "test"]

        // When: the user performs split
        sut.performSplit()

        // Then: should split by whitespace
        XCTAssertEqual(sut.outputParts.count, 3, "Should split into 3 parts")
        XCTAssertTrue(sut.outputParts.allSatisfy { !$0.isEmpty }, "All parts should be non-empty")
    }

    func testFeature_SplitText_NoMatches_ReturnsOriginalText() {
        // Given: a pattern that doesn't match
        sut.pattern = "xyz"
        sut.inputText = "abc def ghi"
        mockRegexEngine.splitResult = ["abc def ghi"]

        // When: the user performs split
        sut.performSplit()

        // Then: should return original text as single part
        XCTAssertEqual(sut.outputParts.count, 1, "Should have one part")
        XCTAssertEqual(sut.outputParts[0], sut.inputText, "Should be original text")
    }

    func testFeature_SplitText_InvalidPattern_ShowsError() {
        // Given: an invalid pattern
        sut.pattern = "("
        sut.inputText = "test"
        mockRegexEngine.splitError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid pattern"])

        // When: the user performs split
        sut.performSplit()

        // Then: an error should be shown
        XCTAssertNotNil(sut.error, "Should have an error")
        XCTAssertTrue(sut.outputParts.isEmpty, "Should have no output parts")
    }

    func testFeature_SplitText_WithMultipleDelimiters_SplitsCorrectly() {
        // Given: a pattern matching multiple delimiters
        sut.pattern = "[,\\s]+"
        sut.inputText = "a, b, c"
        mockRegexEngine.splitResult = ["a", "b", "c"]

        // When: the user performs split
        sut.performSplit()

        // Then: should split correctly
        XCTAssertEqual(sut.outputParts.count, 3, "Should split into 3 parts")
    }

    func testFeature_CopyResult_ToClipboard_CopiesOutputText() {
        // Given: some output parts
        sut.outputParts = ["part1", "part2", "part3"]

        // When: the user copies to clipboard
        sut.copyToClipboard()

        // Then: clipboard should contain the text
        XCTAssertTrue(sut.copyToClipboardCalled, "Should call copy to clipboard")
    }
}
