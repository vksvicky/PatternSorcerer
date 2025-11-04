//
//  TestCaseResult.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Result of running a test case
struct TestCaseResult: Identifiable, Hashable {
    let id: UUID
    let testCase: TestCase
    let actualMatches: Int
    let passed: Bool
    let matches: [MatchResult]

    init(
        id: UUID = UUID(),
        testCase: TestCase,
        actualMatches: Int,
        passed: Bool,
        matches: [MatchResult] = []
    ) {
        self.id = id
        self.testCase = testCase
        self.actualMatches = actualMatches
        self.passed = passed
        self.matches = matches
    }

    var expectedMatches: Int {
        testCase.expectedMatches
    }

    var shouldMatch: Bool {
        testCase.shouldMatch
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(testCase.id)
        hasher.combine(actualMatches)
        hasher.combine(passed)
    }

    static func == (lhs: TestCaseResult, rhs: TestCaseResult) -> Bool {
        lhs.id == rhs.id &&
        lhs.testCase.id == rhs.testCase.id &&
        lhs.actualMatches == rhs.actualMatches &&
        lhs.passed == rhs.passed
    }
}
