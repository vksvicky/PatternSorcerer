//
//  MockTestSuiteService.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

import Foundation
@testable import PatternSorcerer

class MockTestSuiteService: TestSuiteServiceProtocol {
    var saveTestCasesCalled = false
    var savedPattern: Pattern?
    var savedTestCases: [TestCase] = []

    var runAllTestsCalled = false
    var runPattern: Pattern?
    var runTestCases: [TestCase] = []

    var exportTestCasesCalled = false
    var exportedTestCases: [TestCase] = []
    var exportedData: Data?

    var importTestCasesCalled = false
    var importedData: Data?
    var importedTestCases: [TestCase] = []

    func saveTestCases(_ testCases: [TestCase], for pattern: Pattern) throws {
        saveTestCasesCalled = true
        savedPattern = pattern
        savedTestCases = testCases
    }

    func runAllTests(pattern: Pattern, testCases: [TestCase], regexEngine: RegexEngineProtocol) throws -> [TestCaseResult] {
        runAllTestsCalled = true
        runPattern = pattern
        runTestCases = testCases

        return testCases.map { testCase in
            let matches = try? regexEngine.match(pattern: pattern.pattern, in: testCase.testText, options: [])
            let actualMatches = matches?.count ?? 0
            let passed = actualMatches == testCase.expectedMatches && (matches?.isEmpty == !testCase.shouldMatch)

            return TestCaseResult(
                testCase: testCase,
                actualMatches: actualMatches,
                passed: passed,
                matches: matches ?? []
            )
        }
    }

    func exportTestCases(_ testCases: [TestCase]) throws -> Data {
        exportTestCasesCalled = true
        exportedTestCases = testCases

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(testCases.map { ExportableTestCase(testCase: $0) })
        exportedData = data
        return data
    }

    func importTestCases(from data: Data) throws -> [TestCase] {
        importTestCasesCalled = true
        importedData = data

        // If data is empty and we have importedTestCases set, return those
        if data.isEmpty && !importedTestCases.isEmpty {
            return importedTestCases
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let exportableTestCases = try decoder.decode([ExportableTestCase].self, from: data)
        let testCases = exportableTestCases.map { $0.toTestCase() }
        importedTestCases = testCases
        return testCases
    }

    func getTemplates() -> [TestCaseTemplate] {
        return [
            TestCaseTemplate(name: "Email Template", testText: "test@example.com", expectedMatches: 1, shouldMatch: true),
            TestCaseTemplate(name: "URL Template", testText: "https://example.com", expectedMatches: 1, shouldMatch: true),
            TestCaseTemplate(name: "Phone Template", testText: "123-456-7890", expectedMatches: 1, shouldMatch: true)
        ]
    }
}

// Helper struct for Codable conformance
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
