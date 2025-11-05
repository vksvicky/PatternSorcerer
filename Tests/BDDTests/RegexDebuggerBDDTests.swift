//
//  RegexDebuggerBDDTests.swift
//  PatternSorcererTests
//
//  BDD-style tests for Regex Debugger/Stepper feature
//
//  Created on 2024-12-XX
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class RegexDebuggerBDDTests: XCTestCase {
    var sut: RegexDebuggerViewModel!
    var mockDebuggerService: MockRegexDebuggerService!
    var mockRegexEngine: MockRegexEngine!

    override func setUp() {
        super.setUp()
        mockDebuggerService = MockRegexDebuggerService()
        mockRegexEngine = MockRegexEngine()
        sut = RegexDebuggerViewModel(
            debuggerService: mockDebuggerService,
            regexEngine: mockRegexEngine
        )
    }

    override func tearDown() {
        sut = nil
        mockDebuggerService = nil
        mockRegexEngine = nil
        super.tearDown()
    }

    // MARK: - Feature: Step-through Regex Execution

    func testFeature_StepThroughExecution_SimplePattern_StepsThroughMatch() {
        // Given: a simple pattern and test text
        sut.pattern = "hello"
        sut.testText = "hello world"
        mockDebuggerService.stepResults = [
            RegexDebugStep(
                stepNumber: 1,
                patternPosition: 0,
                textPosition: 0,
                matchedText: "",
                state: .matching,
                description: "Starting match at position 0"
            ),
            RegexDebugStep(
                stepNumber: 2,
                patternPosition: 5,
                textPosition: 5,
                matchedText: "hello",
                state: .matchFound,
                description: "Match found: 'hello'"
            )
        ]

        // When: the user starts debugging
        sut.startDebugging()

        // Then: debugging should be active and first step should be shown
        XCTAssertTrue(sut.isDebuggingActive, "Debugging should be active")
        XCTAssertEqual(sut.currentStep?.stepNumber, 1, "Should show first step")
        XCTAssertEqual(sut.currentStep?.patternPosition, 0, "Should start at pattern position 0")
        XCTAssertEqual(sut.currentStep?.textPosition, 0, "Should start at text position 0")
    }

    func testFeature_StepThroughExecution_StepNext_AdvancesToNextStep() {
        // Given: debugging has started with multiple steps
        sut.pattern = "hello"
        sut.testText = "hello world"
        mockDebuggerService.stepResults = [
            RegexDebugStep(stepNumber: 1, patternPosition: 0, textPosition: 0, matchedText: "", state: .matching, description: "Step 1"),
            RegexDebugStep(stepNumber: 2, patternPosition: 5, textPosition: 5, matchedText: "hello", state: .matchFound, description: "Step 2")
        ]
        sut.startDebugging()

        // When: the user clicks next step
        sut.stepNext()

        // Then: should advance to next step
        XCTAssertEqual(sut.currentStep?.stepNumber, 2, "Should advance to step 2")
        XCTAssertEqual(sut.currentStep?.matchedText, "hello", "Should show matched text")
    }

    func testFeature_StepThroughExecution_StepPrevious_GoesBackToPreviousStep() {
        // Given: debugging is on step 2
        sut.pattern = "hello"
        sut.testText = "hello world"
        mockDebuggerService.stepResults = [
            RegexDebugStep(stepNumber: 1, patternPosition: 0, textPosition: 0, matchedText: "", state: .matching, description: "Step 1"),
            RegexDebugStep(stepNumber: 2, patternPosition: 5, textPosition: 5, matchedText: "hello", state: .matchFound, description: "Step 2")
        ]
        sut.startDebugging()
        sut.stepNext()

        // When: the user clicks previous step
        sut.stepPrevious()

        // Then: should go back to previous step
        XCTAssertEqual(sut.currentStep?.stepNumber, 1, "Should go back to step 1")
    }

    func testFeature_StepThroughExecution_AtLastStep_StepNext_DoesNothing() {
        // Given: debugging is on the last step
        sut.pattern = "hello"
        sut.testText = "hello world"
        mockDebuggerService.stepResults = [
            RegexDebugStep(stepNumber: 1, patternPosition: 0, textPosition: 0, matchedText: "", state: .matching, description: "Step 1"),
            RegexDebugStep(stepNumber: 2, patternPosition: 5, textPosition: 5, matchedText: "hello", state: .matchFound, description: "Step 2")
        ]
        sut.startDebugging()
        sut.stepNext()

        // When: the user clicks next step at the end
        sut.stepNext()

        // Then: should remain on last step
        XCTAssertEqual(sut.currentStep?.stepNumber, 2, "Should remain on last step")
    }

    func testFeature_StepThroughExecution_AtFirstStep_StepPrevious_DoesNothing() {
        // Given: debugging is on the first step
        sut.pattern = "hello"
        sut.testText = "hello world"
        mockDebuggerService.stepResults = [
            RegexDebugStep(stepNumber: 1, patternPosition: 0, textPosition: 0, matchedText: "", state: .matching, description: "Step 1")
        ]
        sut.startDebugging()

        // When: the user clicks previous step at the beginning
        sut.stepPrevious()

        // Then: should remain on first step
        XCTAssertEqual(sut.currentStep?.stepNumber, 1, "Should remain on first step")
    }

    // MARK: - Feature: Backtracking Visualization

    func testFeature_BacktrackingVisualization_ShowsBacktrackingSteps() {
        // Given: a pattern that causes backtracking
        sut.pattern = ".*x"
        sut.testText = "abcx"
        mockDebuggerService.stepResults = [
            RegexDebugStep(stepNumber: 1, patternPosition: 0, textPosition: 0, matchedText: "", state: .matching, description: "Start"),
            RegexDebugStep(stepNumber: 2, patternPosition: 1, textPosition: 4, matchedText: "abcx", state: .backtracking, description: "Backtracking from position 4"),
            RegexDebugStep(stepNumber: 3, patternPosition: 2, textPosition: 3, matchedText: "abc", state: .matchFound, description: "Match found")
        ]

        // When: the user starts debugging
        sut.startDebugging()
        sut.stepNext()

        // Then: backtracking step should be detected
        XCTAssertEqual(sut.currentStep?.state, .backtracking, "Should detect backtracking state")
        XCTAssertTrue(sut.hasBacktracking, "Should indicate backtracking occurred")
    }

    // MARK: - Feature: Position Highlighting

    func testFeature_PositionHighlighting_CurrentPatternPosition_HighlightsCorrectCharacter() {
        // Given: debugging is active at a specific pattern position
        sut.pattern = "hello"
        sut.testText = "hello world"
        mockDebuggerService.stepResults = [
            RegexDebugStep(stepNumber: 1, patternPosition: 2, textPosition: 2, matchedText: "he", state: .matching, description: "At position 2")
        ]
        sut.startDebugging()

        // When: current step shows pattern position
        let highlightedPosition = sut.currentPatternPosition

        // Then: should return correct pattern position for highlighting
        XCTAssertEqual(highlightedPosition, 2, "Should return correct pattern position")
    }

    func testFeature_PositionHighlighting_CurrentTextPosition_HighlightsCorrectCharacter() {
        // Given: debugging is active at a specific text position
        sut.pattern = "hello"
        sut.testText = "hello world"
        mockDebuggerService.stepResults = [
            RegexDebugStep(stepNumber: 1, patternPosition: 2, textPosition: 3, matchedText: "hel", state: .matching, description: "At text position 3")
        ]
        sut.startDebugging()

        // When: current step shows text position
        let highlightedPosition = sut.currentTextPosition

        // Then: should return correct text position for highlighting
        XCTAssertEqual(highlightedPosition, 3, "Should return correct text position")
    }

    // MARK: - Feature: State Transitions

    func testFeature_StateTransitions_ShowsAllStates() {
        // Given: steps with different states
        sut.pattern = "hello"
        sut.testText = "hello world"
        mockDebuggerService.stepResults = [
            RegexDebugStep(stepNumber: 1, patternPosition: 0, textPosition: 0, matchedText: "", state: .matching, description: "Matching"),
            RegexDebugStep(stepNumber: 2, patternPosition: 5, textPosition: 5, matchedText: "hello", state: .matchFound, description: "Match found"),
            RegexDebugStep(stepNumber: 3, patternPosition: 5, textPosition: 6, matchedText: "hello", state: .noMatch, description: "No match")
        ]

        // When: stepping through all states
        sut.startDebugging()
        let state1 = sut.currentStep?.state
        sut.stepNext()
        let state2 = sut.currentStep?.state
        sut.stepNext()
        let state3 = sut.currentStep?.state

        // Then: should show all state transitions
        XCTAssertEqual(state1, .matching, "Should show matching state")
        XCTAssertEqual(state2, .matchFound, "Should show match found state")
        XCTAssertEqual(state3, .noMatch, "Should show no match state")
    }

    // MARK: - Feature: Stop Debugging

    func testFeature_StopDebugging_StopsActiveDebugging() {
        // Given: debugging is active
        sut.pattern = "hello"
        sut.testText = "hello world"
        mockDebuggerService.stepResults = [
            RegexDebugStep(stepNumber: 1, patternPosition: 0, textPosition: 0, matchedText: "", state: .matching, description: "Step 1")
        ]
        sut.startDebugging()

        // When: the user stops debugging
        sut.stopDebugging()

        // Then: debugging should be inactive
        XCTAssertFalse(sut.isDebuggingActive, "Debugging should be inactive")
        XCTAssertNil(sut.currentStep, "Current step should be cleared")
    }
}
