//
//  TestSuiteService.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation
import SwiftData

/// Service for managing test suites
class TestSuiteService: TestSuiteServiceProtocol {
    // MARK: - Initialization

    init() {
        Logger.debug("TestSuiteService initialized")
    }

    // MARK: - Save Test Cases

    func saveTestCases(_ testCases: [TestCase], for pattern: Pattern) throws {
        Logger.debug("Saving \(testCases.count) test cases for pattern: \(pattern.name)")
        pattern.testCases = testCases
        pattern.updatedAt = Date()
        Logger.info("Successfully saved test cases")
    }

    // MARK: - Run All Tests

    func runAllTests(
        pattern: Pattern,
        testCases: [TestCase],
        regexEngine: RegexEngineProtocol
    ) throws -> [TestCaseResult] {
        Logger.debug("Running \(testCases.count) test cases for pattern: \(pattern.name)")

        var results: [TestCaseResult] = []

        for testCase in testCases {
            do {
                let matches = try regexEngine.match(pattern: pattern.pattern, in: testCase.testText, options: [])
                let actualMatches = matches.count
                let passed = actualMatches == testCase.expectedMatches && (matches.isEmpty == !testCase.shouldMatch)

                let result = TestCaseResult(
                    testCase: testCase,
                    actualMatches: actualMatches,
                    passed: passed,
                    matches: matches
                )
                results.append(result)

                Logger.debug("Test case '\(testCase.name)': \(passed ? "PASSED" : "FAILED")")
            } catch {
                Logger.error("Error running test case '\(testCase.name)': \(error.localizedDescription)")
                let result = TestCaseResult(
                    testCase: testCase,
                    actualMatches: 0,
                    passed: false,
                    matches: []
                )
                results.append(result)
            }
        }

        let passedCount = results.filter { $0.passed }.count
        Logger.info("Test suite completed: \(passedCount)/\(results.count) tests passed")
        return results
    }

    // MARK: - Export/Import

    func exportTestCases(_ testCases: [TestCase]) throws -> Data {
        Logger.debug("Exporting \(testCases.count) test cases")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601

        let exportableTestCases = testCases.map { ExportableTestCase(testCase: $0) }
        let data = try encoder.encode(exportableTestCases)
        Logger.info("Successfully exported test cases")
        return data
    }

    func importTestCases(from data: Data) throws -> [TestCase] {
        Logger.debug("Importing test cases from data")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let exportableTestCases = try decoder.decode([ExportableTestCase].self, from: data)
        let testCases = exportableTestCases.map { $0.toTestCase() }
        Logger.info("Successfully imported \(testCases.count) test cases")
        return testCases
    }

    // MARK: - Templates

    func getTemplates() -> [TestCaseTemplate] {
        return [
            TestCaseTemplate(
                name: "Email Template",
                testText: "test@example.com",
                expectedMatches: 1,
                shouldMatch: true,
                description: "Template for email validation"
            ),
            TestCaseTemplate(
                name: "URL Template",
                testText: "https://example.com",
                expectedMatches: 1,
                shouldMatch: true,
                description: "Template for URL validation"
            ),
            TestCaseTemplate(
                name: "Phone Template",
                testText: "123-456-7890",
                expectedMatches: 1,
                shouldMatch: true,
                description: "Template for phone number validation"
            ),
            TestCaseTemplate(
                name: "Negative Test Template",
                testText: "invalid",
                expectedMatches: 0,
                shouldMatch: false,
                description: "Template for negative test cases"
            )
        ]
    }
}

// MARK: - Exportable Test Case

private struct ExportableTestCase: Codable {
    let id: UUID
    let name: String
    let testText: String
    let expectedMatches: Int
    let shouldMatch: Bool
    let createdAt: Date

    init(testCase: TestCase) {
        self.id = testCase.id
        self.name = testCase.name
        self.testText = testCase.testText
        self.expectedMatches = testCase.expectedMatches
        self.shouldMatch = testCase.shouldMatch
        self.createdAt = testCase.createdAt
    }

    func toTestCase() -> TestCase {
        TestCase(
            id: id,
            name: name,
            testText: testText,
            expectedMatches: expectedMatches,
            shouldMatch: shouldMatch,
            createdAt: createdAt
        )
    }
}
