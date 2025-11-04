//
//  TestSuiteServiceTests.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

final class TestSuiteServiceTests: XCTestCase {
    var sut: TestSuiteService!
    var mockRegexEngine: MockRegexEngine!

    override func setUp() {
        super.setUp()
        mockRegexEngine = MockRegexEngine()
        sut = TestSuiteService()
    }

    override func tearDown() {
        sut = nil
        mockRegexEngine = nil
        super.tearDown()
    }

    // MARK: - Save Test Cases

    func testSaveTestCases_ValidPattern_StoresTestCases() throws {
        // Given
        let pattern = Pattern(name: "Test", pattern: "\\d+")
        let testCases = [
            TestCase(name: "Test 1", testText: "123", expectedMatches: 1, shouldMatch: true),
            TestCase(name: "Test 2", testText: "abc", expectedMatches: 0, shouldMatch: false)
        ]

        // When
        try sut.saveTestCases(testCases, for: pattern)

        // Then
        XCTAssertEqual(pattern.testCases.count, 2, "Should save both test cases")
        XCTAssertEqual(pattern.testCases[0].name, "Test 1", "Should save first test case")
        XCTAssertEqual(pattern.testCases[1].name, "Test 2", "Should save second test case")
    }

    // MARK: - Run All Tests

    func testRunAllTests_ValidPattern_RunsAllTestCases() throws {
        // Given
        let pattern = Pattern(name: "Digits", pattern: "\\d+")
        let testCases = [
            TestCase(name: "Test 1", testText: "123", expectedMatches: 1, shouldMatch: true),
            TestCase(name: "Test 2", testText: "456", expectedMatches: 1, shouldMatch: true)
        ]
        let regexEngine = RegexEngine()

        // When
        let results = try sut.runAllTests(pattern: pattern, testCases: testCases, regexEngine: regexEngine)

        // Then
        XCTAssertEqual(results.count, 2, "Should return results for all test cases")
        XCTAssertTrue(results.allSatisfy { $0.passed }, "All tests should pass")
    }

    func testRunAllTests_FailedTest_ReturnsFailedResult() throws {
        // Given
        let pattern = Pattern(name: "Digits", pattern: "\\d+")
        let testCase = TestCase(name: "Test 1", testText: "abc", expectedMatches: 1, shouldMatch: true)
        let regexEngine = RegexEngine()

        // When
        let results = try sut.runAllTests(pattern: pattern, testCases: [testCase], regexEngine: regexEngine)

        // Then
        let result = results.first!
        XCTAssertFalse(result.passed, "Test should fail when no matches found")
        XCTAssertEqual(result.actualMatches, 0, "Should show 0 actual matches")
        XCTAssertEqual(result.expectedMatches, 1, "Should show 1 expected match")
    }

    func testRunAllTests_InvalidPattern_ReturnsFailedResult() throws {
        // Given
        let pattern = Pattern(name: "Invalid", pattern: "(")
        let testCase = TestCase(name: "Test", testText: "test", expectedMatches: 1, shouldMatch: true)
        let regexEngine = RegexEngine()

        // When
        let results = try sut.runAllTests(pattern: pattern, testCases: [testCase], regexEngine: regexEngine)

        // Then
        let result = results.first!
        XCTAssertFalse(result.passed, "Test should fail for invalid pattern")
        XCTAssertEqual(result.actualMatches, 0, "Should show 0 actual matches")
    }

    // MARK: - Export/Import

    func testExportTestCases_ValidTestCases_GeneratesJSON() throws {
        // Given
        let testCases = [
            TestCase(name: "Test 1", testText: "123", expectedMatches: 1, shouldMatch: true),
            TestCase(name: "Test 2", testText: "abc", expectedMatches: 0, shouldMatch: false)
        ]

        // When
        let data = try sut.exportTestCases(testCases)

        // Then
        XCTAssertFalse(data.isEmpty, "Should generate non-empty JSON")
        let jsonString = String(data: data, encoding: .utf8)
        XCTAssertNotNil(jsonString, "Should be valid UTF-8")
        XCTAssertTrue(jsonString!.contains("Test 1"), "Should contain first test case")
        XCTAssertTrue(jsonString!.contains("Test 2"), "Should contain second test case")
    }

    func testImportTestCases_ValidJSON_LoadsTestCases() throws {
        // Given
        let testCases = [
            TestCase(name: "Test 1", testText: "123", expectedMatches: 1, shouldMatch: true),
            TestCase(name: "Test 2", testText: "abc", expectedMatches: 0, shouldMatch: false)
        ]
        let data = try sut.exportTestCases(testCases)

        // When
        let imported = try sut.importTestCases(from: data)

        // Then
        XCTAssertEqual(imported.count, 2, "Should import both test cases")
        XCTAssertEqual(imported[0].name, "Test 1", "Should preserve first test case name")
        XCTAssertEqual(imported[1].name, "Test 2", "Should preserve second test case name")
    }

    func testImportTestCases_InvalidJSON_ThrowsError() {
        // Given
        let invalidData = Data("invalid json".utf8)

        // When & Then
        XCTAssertThrowsError(try sut.importTestCases(from: invalidData)) { error in
            XCTAssertNotNil(error, "Should throw error for invalid JSON")
        }
    }

    // MARK: - Templates

    func testGetTemplates_ReturnsAvailableTemplates() {
        // When
        let templates = sut.getTemplates()

        // Then
        XCTAssertFalse(templates.isEmpty, "Should return templates")
        XCTAssertTrue(templates.contains { $0.name == "Email Template" }, "Should include email template")
        XCTAssertTrue(templates.contains { $0.name == "URL Template" }, "Should include URL template")
    }
}
