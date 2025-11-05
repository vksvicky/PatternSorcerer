//
//  MockRegexDebuggerService.swift
//  PatternSorcererTests
//
//  Mock implementation of RegexDebuggerServiceProtocol for testing
//
//  Created on 2024-12-XX
//

import Foundation
@testable import PatternSorcerer

/// Mock regex debugger service for testing
class MockRegexDebuggerService: RegexDebuggerServiceProtocol {
    // MARK: - Configuration

    var stepResults: [RegexDebugStep] = []
    var debugError: Error?
    var shouldThrowError = false
    var startDebuggingCalled = false
    var stopDebuggingCalled = false
    var stepNextCalled = false
    var stepPreviousCalled = false

    // MARK: - RegexDebuggerServiceProtocol

    func startDebugging(pattern: String, text: String) throws -> [RegexDebugStep] {
        startDebuggingCalled = true
        if shouldThrowError || debugError != nil {
            throw debugError ?? NSError(
                domain: "TestError",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Debugging error"]
            )
        }
        return stepResults
    }

    func stopDebugging() {
        stopDebuggingCalled = true
    }

    func getCurrentStep() -> RegexDebugStep? {
        return stepResults.first
    }

    func getStep(at index: Int) -> RegexDebugStep? {
        guard index >= 0 && index < stepResults.count else { return nil }
        return stepResults[index]
    }

    func getTotalSteps() -> Int {
        return stepResults.count
    }

    func hasBacktracking() -> Bool {
        return stepResults.contains { $0.state == .backtracking }
    }
}
