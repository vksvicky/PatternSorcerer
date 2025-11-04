//
//  TestSuiteServiceProtocol.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Protocol for test suite management operations
protocol TestSuiteServiceProtocol {
    /// Save test cases to a pattern
    func saveTestCases(_ testCases: [TestCase], for pattern: Pattern) throws

    /// Run all test cases for a pattern
    func runAllTests(
        pattern: Pattern,
        testCases: [TestCase],
        regexEngine: RegexEngineProtocol
    ) throws -> [TestCaseResult]

    /// Export test cases to JSON
    func exportTestCases(_ testCases: [TestCase]) throws -> Data

    /// Import test cases from JSON
    func importTestCases(from data: Data) throws -> [TestCase]

    /// Get available test case templates
    func getTemplates() -> [TestCaseTemplate]
}
