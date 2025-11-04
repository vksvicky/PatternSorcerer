//
//  ReplaceToolBDDTests.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class ReplaceToolBDDTests: XCTestCase {
    var sut: ReplaceToolViewModel!
    var mockRegexEngine: MockRegexEngine!

    override func setUp() {
        super.setUp()
        mockRegexEngine = MockRegexEngine()
        sut = ReplaceToolViewModel(regexEngine: mockRegexEngine)
    }

    override func tearDown() {
        sut = nil
        mockRegexEngine = nil
        super.tearDown()
    }

    // MARK: - Feature: Replace with Regex

    func testFeature_ReplaceText_WithPattern_ReplacesMatches() {
        // Given: a pattern, text, and replacement string
        sut.pattern = "\\d+"
        sut.inputText = "I have 5 apples and 10 oranges"
        sut.replacementText = "X"
        mockRegexEngine.replaceResult = "I have X apples and X oranges"

        // When: the user performs replace
        sut.performReplace()

        // Then: the text should be replaced
        XCTAssertFalse(sut.outputText.isEmpty, "Should have output text")
        XCTAssertTrue(sut.outputText.contains("X"), "Should contain replacement")
        XCTAssertFalse(sut.outputText.contains("5"), "Should not contain original number")
        XCTAssertFalse(sut.outputText.contains("10"), "Should not contain original number")
    }

    func testFeature_ReplaceText_WithCaptureGroups_ReplacesWithGroups() {
        // Given: a pattern with capture groups and replacement using groups
        sut.pattern = "(\\d+)-(\\d+)"
        sut.inputText = "Phone: 555-1234"
        sut.replacementText = "($1) $2"
        mockRegexEngine.replaceResult = "Phone: (555) 1234"

        // When: the user performs replace
        sut.performReplace()

        // Then: the replacement should use capture groups
        XCTAssertTrue(sut.outputText.contains("(555)"), "Should use first capture group")
        XCTAssertTrue(sut.outputText.contains("1234"), "Should use second capture group")
    }

    func testFeature_ReplaceText_AllMatches_ReplacesAllOccurrences() {
        // Given: a pattern that matches multiple times
        sut.pattern = "cat"
        sut.inputText = "The cat sat on the cat mat"
        sut.replacementText = "dog"
        mockRegexEngine.replaceResult = "The dog sat on the dog mat"

        // When: the user performs replace
        sut.performReplace()

        // Then: all occurrences should be replaced
        let dogCount = sut.outputText.components(separatedBy: "dog").count - 1
        XCTAssertEqual(dogCount, 2, "Should replace all occurrences")
    }

    func testFeature_ReplaceText_InvalidPattern_ShowsError() {
        // Given: an invalid pattern
        sut.pattern = "("
        sut.inputText = "test"
        sut.replacementText = "replacement"
        let testError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid pattern"])
        mockRegexEngine.replaceError = testError

        // When: the user performs replace
        sut.performReplace()

        // Then: an error should be shown
        XCTAssertNotNil(sut.error, "Should have an error")
        XCTAssertTrue(sut.outputText.isEmpty, "Should have no output text")
    }

    func testFeature_ReplaceText_NoMatches_ReturnsOriginalText() {
        // Given: a pattern that doesn't match
        sut.pattern = "xyz"
        sut.inputText = "abc def ghi"
        sut.replacementText = "replacement"
        mockRegexEngine.replaceResult = "abc def ghi"

        // When: the user performs replace
        sut.performReplace()

        // Then: original text should be returned
        XCTAssertEqual(sut.outputText, sut.inputText, "Should return original text when no matches")
    }

    func testFeature_ReplaceText_CaseInsensitive_ReplacesCaseInsensitive() {
        // Given: case-insensitive option enabled
        sut.pattern = "cat"
        sut.inputText = "The Cat sat on the CAT mat"
        sut.replacementText = "dog"
        sut.options.caseInsensitive = true
        mockRegexEngine.replaceResult = "The dog sat on the dog mat"

        // When: the user performs replace
        sut.performReplace()

        // Then: all case variations should be replaced
        XCTAssertTrue(sut.outputText.contains("dog"), "Should replace case variations")
    }

    func testFeature_CopyResult_ToClipboard_CopiesOutputText() {
        // Given: some output text
        sut.outputText = "Replaced text"

        // When: the user copies to clipboard
        sut.copyToClipboard()

        // Then: clipboard should contain the text
        // This would be verified via a mock clipboard service in real implementation
        XCTAssertTrue(sut.copyToClipboardCalled, "Should call copy to clipboard")
    }
}
