//
//  ExtractToolBDDTests.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class ExtractToolBDDTests: XCTestCase {
    var sut: ExtractToolViewModel!
    var mockRegexEngine: MockRegexEngine!

    override func setUp() {
        super.setUp()
        mockRegexEngine = MockRegexEngine()
        sut = ExtractToolViewModel(regexEngine: mockRegexEngine)
    }

    override func tearDown() {
        sut = nil
        mockRegexEngine = nil
        super.tearDown()
    }

    // MARK: - Feature: Extract Groups with Regex

    func testFeature_ExtractGroups_WithCaptureGroups_ExtractsGroups() {
        // Given: a pattern with capture groups and text
        sut.pattern = "(\\d+)-(\\d+)"
        sut.inputText = "Phone: 555-1234"
        let matchResult = MatchResult(
            range: NSRange(location: 7, length: 8),
            matchedText: "555-1234",
            captureGroups: [
                CaptureGroup(index: 1, range: NSRange(location: 7, length: 3), text: "555"),
                CaptureGroup(index: 2, range: NSRange(location: 11, length: 4), text: "1234")
            ],
            matchNumber: 1
        )
        mockRegexEngine.matchResult = [matchResult]

        // When: the user performs extract
        sut.performExtract()

        // Then: capture groups should be extracted
        XCTAssertEqual(sut.extractedGroups.count, 2, "Should extract 2 groups")
        XCTAssertEqual(sut.extractedGroups[0].text, "555", "First group should be 555")
        XCTAssertEqual(sut.extractedGroups[1].text, "1234", "Second group should be 1234")
    }

    func testFeature_ExtractGroups_MultipleMatches_ExtractsAllGroups() {
        // Given: a pattern that matches multiple times
        sut.pattern = "(\\w+)"
        sut.inputText = "hello world"
        let match1 = MatchResult(
            range: NSRange(location: 0, length: 5),
            matchedText: "hello",
            captureGroups: [
                CaptureGroup(index: 1, range: NSRange(location: 0, length: 5), text: "hello")
            ],
            matchNumber: 1
        )
        let match2 = MatchResult(
            range: NSRange(location: 6, length: 5),
            matchedText: "world",
            captureGroups: [
                CaptureGroup(index: 1, range: NSRange(location: 6, length: 5), text: "world")
            ],
            matchNumber: 2
        )
        mockRegexEngine.matchResult = [match1, match2]

        // When: the user performs extract
        sut.performExtract()

        // Then: all groups should be extracted
        XCTAssertEqual(sut.extractedGroups.count, 2, "Should extract 2 groups")
    }

    func testFeature_ExtractGroups_SpecificGroupIndex_ExtractsOnlyThatGroup() {
        // Given: a pattern with multiple groups and specific index selected
        sut.pattern = "(\\d+)-(\\d+)-(\\d+)"
        sut.inputText = "Date: 2025-11-04"
        sut.selectedGroupIndex = 2
        let matchResult = MatchResult(
            range: NSRange(location: 6, length: 10),
            matchedText: "2025-11-04",
            captureGroups: [
                CaptureGroup(index: 1, range: NSRange(location: 6, length: 4), text: "2025"),
                CaptureGroup(index: 2, range: NSRange(location: 11, length: 2), text: "11"),
                CaptureGroup(index: 3, range: NSRange(location: 14, length: 2), text: "04")
            ],
            matchNumber: 1
        )
        mockRegexEngine.matchResult = [matchResult]

        // When: the user performs extract
        sut.performExtract()

        // Then: only the selected group should be extracted
        XCTAssertEqual(sut.extractedGroups.count, 1, "Should extract only selected group")
        XCTAssertEqual(sut.extractedGroups[0].text, "11", "Should extract group 2")
    }

    func testFeature_ExtractGroups_NoCaptureGroups_ShowsError() {
        // Given: a pattern without capture groups
        sut.pattern = "\\d+"
        sut.inputText = "123"
        mockRegexEngine.matchResult = []

        // When: the user performs extract
        sut.performExtract()

        // Then: should show appropriate message
        XCTAssertTrue(sut.extractedGroups.isEmpty, "Should have no extracted groups")
    }

    func testFeature_ExtractGroups_InvalidPattern_ShowsError() {
        // Given: an invalid pattern
        sut.pattern = "("
        sut.inputText = "test"
        mockRegexEngine.matchError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid pattern"])

        // When: the user performs extract
        sut.performExtract()

        // Then: an error should be shown
        XCTAssertNotNil(sut.error, "Should have an error")
        XCTAssertTrue(sut.extractedGroups.isEmpty, "Should have no extracted groups")
    }

    func testFeature_CopyResult_ToClipboard_CopiesExtractedGroups() {
        // Given: some extracted groups
        sut.extractedGroups = [
            CaptureGroup(index: 1, range: NSRange(location: 0, length: 3), text: "abc"),
            CaptureGroup(index: 2, range: NSRange(location: 4, length: 3), text: "def")
        ]

        // When: the user copies to clipboard
        sut.copyToClipboard()

        // Then: clipboard should contain the groups
        XCTAssertTrue(sut.copyToClipboardCalled, "Should call copy to clipboard")
    }
}
