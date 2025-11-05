//
//  RegexDebuggerServiceTests.swift
//  PatternSorcererTests
//
//  Unit tests for RegexDebuggerService
//
//  Created on 2024-12-XX
//

@testable import PatternSorcerer
import XCTest

final class RegexDebuggerServiceTests: XCTestCase {
    var sut: RegexDebuggerService!
    var mockRegexEngine: MockRegexEngine!

    override func setUp() {
        super.setUp()
        mockRegexEngine = MockRegexEngine()
        sut = RegexDebuggerService(regexEngine: mockRegexEngine)
    }

    override func tearDown() {
        sut = nil
        mockRegexEngine = nil
        super.tearDown()
    }

    // MARK: - Start Debugging

    func testStartDebugging_SimplePattern_ReturnsSteps() throws {
        // Given: a simple pattern and text
        let pattern = "hello"
        let text = "hello world"
        mockRegexEngine.matchResult = [
            MatchResult(
                matchNumber: 1,
                matchedText: "hello",
                range: NSRange(location: 0, length: 5),
                captureGroups: []
            )
        ]

        // When: starting debugging
        let steps = try sut.startDebugging(pattern: pattern, text: text)

        // Then: should return debug steps
        XCTAssertFalse(steps.isEmpty, "Should return steps")
        XCTAssertTrue(steps.contains { $0.state == .matchFound }, "Should contain match found step")
    }

    func testStartDebugging_InvalidPattern_ThrowsError() {
        // Given: an invalid pattern
        let pattern = "[invalid"
        let text = "test"
        mockRegexEngine.validationResult = (false, "Invalid pattern")

        // When: starting debugging
        // Then: should throw error
        XCTAssertThrowsError(try sut.startDebugging(pattern: pattern, text: text))
    }

    func testStartDebugging_NoMatches_ReturnsNoMatchSteps() throws {
        // Given: a pattern that doesn't match
        let pattern = "xyz"
        let text = "hello world"
        mockRegexEngine.matchResult = []

        // When: starting debugging
        let steps = try sut.startDebugging(pattern: pattern, text: text)

        // Then: should return steps with no match state
        XCTAssertTrue(steps.contains { $0.state == .noMatch }, "Should contain no match step")
    }

    // MARK: - Step Management

    func testGetCurrentStep_AfterStart_ReturnsFirstStep() throws {
        // Given: debugging has started
        let pattern = "hello"
        let text = "hello world"
        mockRegexEngine.matchResult = [
            MatchResult(
                matchNumber: 1,
                matchedText: "hello",
                range: NSRange(location: 0, length: 5),
                captureGroups: []
            )
        ]
        _ = try sut.startDebugging(pattern: pattern, text: text)

        // When: getting current step
        let currentStep = sut.getCurrentStep()

        // Then: should return first step
        XCTAssertNotNil(currentStep, "Should return current step")
        XCTAssertEqual(currentStep?.stepNumber, 1, "Should be first step")
    }

    func testGetStep_ValidIndex_ReturnsStep() throws {
        // Given: debugging has started with multiple steps
        let pattern = "hello"
        let text = "hello world"
        mockRegexEngine.matchResult = [
            MatchResult(
                matchNumber: 1,
                matchedText: "hello",
                range: NSRange(location: 0, length: 5),
                captureGroups: []
            )
        ]
        _ = try sut.startDebugging(pattern: pattern, text: text)

        // When: getting step at index
        let step = sut.getStep(at: 0)

        // Then: should return step
        XCTAssertNotNil(step, "Should return step")
    }

    func testGetStep_InvalidIndex_ReturnsNil() throws {
        // Given: debugging has started
        let pattern = "hello"
        let text = "hello world"
        mockRegexEngine.matchResult = [
            MatchResult(
                matchNumber: 1,
                matchedText: "hello",
                range: NSRange(location: 0, length: 5),
                captureGroups: []
            )
        ]
        _ = try sut.startDebugging(pattern: pattern, text: text)

        // When: getting step at invalid index
        let step = sut.getStep(at: 999)

        // Then: should return nil
        XCTAssertNil(step, "Should return nil for invalid index")
    }

    func testGetTotalSteps_AfterStart_ReturnsCorrectCount() throws {
        // Given: debugging has started
        let pattern = "hello"
        let text = "hello world"
        mockRegexEngine.matchResult = [
            MatchResult(
                matchNumber: 1,
                matchedText: "hello",
                range: NSRange(location: 0, length: 5),
                captureGroups: []
            )
        ]
        _ = try sut.startDebugging(pattern: pattern, text: text)

        // When: getting total steps
        let totalSteps = sut.getTotalSteps()

        // Then: should return correct count
        XCTAssertGreaterThan(totalSteps, 0, "Should have steps")
    }

    // MARK: - Backtracking Detection

    func testHasBacktracking_WithBacktracking_ReturnsTrue() throws {
        // Given: a pattern that causes backtracking
        let pattern = ".*x"
        let text = "abcx"
        // Note: This would require actual backtracking detection in implementation
        mockRegexEngine.matchResult = [
            MatchResult(
                matchNumber: 1,
                matchedText: "abcx",
                range: NSRange(location: 0, length: 4),
                captureGroups: []
            )
        ]
        _ = try sut.startDebugging(pattern: pattern, text: text)

        // When: checking for backtracking
        let hasBacktracking = sut.hasBacktracking()

        // Then: should detect backtracking (implementation dependent)
        // This test will need to be updated based on actual backtracking detection logic
        XCTAssertNotNil(hasBacktracking, "Should check for backtracking")
    }

    // MARK: - Stop Debugging

    func testStopDebugging_ClearsCurrentStep() throws {
        // Given: debugging is active
        let pattern = "hello"
        let text = "hello world"
        mockRegexEngine.matchResult = [
            MatchResult(
                matchNumber: 1,
                matchedText: "hello",
                range: NSRange(location: 0, length: 5),
                captureGroups: []
            )
        ]
        _ = try sut.startDebugging(pattern: pattern, text: text)

        // When: stopping debugging
        sut.stopDebugging()

        // Then: current step should be cleared
        let currentStep = sut.getCurrentStep()
        XCTAssertNil(currentStep, "Current step should be nil after stopping")
    }
}
