//
//  TestSuiteManagerBDDTests.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class TestSuiteManagerBDDTests: XCTestCase {
    var sut: TestSuiteManagerViewModel!
    var mockService: MockTestSuiteService!
    var mockRegexEngine: MockRegexEngine!

    override func setUp() {
        super.setUp()
        mockService = MockTestSuiteService()
        mockRegexEngine = MockRegexEngine()
        sut = TestSuiteManagerViewModel(testSuiteService: mockService, regexEngine: mockRegexEngine)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockRegexEngine = nil
        super.tearDown()
    }

    // MARK: - Feature: Test Suite Management

    func testFeature_SaveTestCases_ToPattern_StoresTestCases() {
        // Given: a pattern and multiple test cases
        let pattern = Pattern(name: "Email", pattern: "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b")
        sut.currentPattern = pattern
        sut.testCases = [
            TestCase(name: "Valid Email", testText: "test@example.com", expectedMatches: 1, shouldMatch: true),
            TestCase(name: "Invalid Email", testText: "invalid", expectedMatches: 0, shouldMatch: false)
        ]

        // When: the user saves the test cases
        sut.saveTestCases()

        // Then: the test cases should be saved to the pattern
        XCTAssertTrue(mockService.saveTestCasesCalled, "Should call save test cases")
        XCTAssertEqual(mockService.savedPattern?.id, pattern.id, "Should save to correct pattern")
        XCTAssertEqual(mockService.savedTestCases.count, 2, "Should save both test cases")
    }

    func testFeature_RunAllTests_ForPattern_RunsAllTestCases() {
        // Given: a pattern with multiple test cases
        let pattern = Pattern(name: "Digits", pattern: "\\d+")
        let testCases = [
            TestCase(name: "Test 1", testText: "123", expectedMatches: 1, shouldMatch: true),
            TestCase(name: "Test 2", testText: "abc", expectedMatches: 0, shouldMatch: false),
            TestCase(name: "Test 3", testText: "456", expectedMatches: 1, shouldMatch: true)
        ]
        pattern.testCases = testCases
        sut.currentPattern = pattern
        sut.testCases = testCases
        mockRegexEngine.matchResults = [
            "123": [MatchResult(range: NSRange(location: 0, length: 3), matchedText: "123", captureGroups: [], matchNumber: 1)],
            "abc": [],
            "456": [MatchResult(range: NSRange(location: 0, length: 3), matchedText: "456", captureGroups: [], matchNumber: 1)]
        ]

        // When: the user runs all tests
        sut.runAllTests()

        // Then: all test cases should be executed
        XCTAssertTrue(mockService.runAllTestsCalled, "Should call run all tests")
        XCTAssertEqual(sut.testResults.count, 3, "Should have results for all test cases")
        // Note: Test 2 should fail because it expects 0 matches but shouldMatch is false
        // The logic checks: actualMatches == expectedMatches && (matches.isEmpty == !shouldMatch)
        // For Test 2: 0 == 0 && (true == !false) = true && true = true
        XCTAssertEqual(sut.testResults.filter { $0.passed }.count, 3, "All tests should pass")
    }

    func testFeature_TestResults_ExpectedVsActual_ShowsComparison() {
        // Given: a pattern and test case with expected results
        let pattern = Pattern(name: "Digits", pattern: "\\d+")
        let testCase = TestCase(name: "Test 1", testText: "123", expectedMatches: 1, shouldMatch: true)
        sut.currentPattern = pattern
        sut.testCases = [testCase]
        mockRegexEngine.matchResults = [
            "123": [MatchResult(range: NSRange(location: 0, length: 3), matchedText: "123", captureGroups: [], matchNumber: 1)]
        ]

        // When: the test is run
        sut.runAllTests()

        // Then: the result should show expected vs actual
        let result = sut.testResults.first!
        XCTAssertEqual(result.expectedMatches, 1, "Should show expected matches")
        XCTAssertEqual(result.actualMatches, 1, "Should show actual matches")
        XCTAssertTrue(result.passed, "Test should pass when expected matches actual")
    }

    func testFeature_TestResults_FailedTest_ShowsFailure() {
        // Given: a test case that should match but doesn't
        let pattern = Pattern(name: "Digits", pattern: "\\d+")
        let testCase = TestCase(name: "Test 1", testText: "abc", expectedMatches: 1, shouldMatch: true)
        sut.currentPattern = pattern
        sut.testCases = [testCase]
        mockRegexEngine.matchResults = ["abc": []]

        // When: the test is run
        sut.runAllTests()

        // Then: the result should show failure
        let result = sut.testResults.first!
        XCTAssertFalse(result.passed, "Test should fail when expected doesn't match actual")
        XCTAssertEqual(result.expectedMatches, 1, "Should show expected matches")
        XCTAssertEqual(result.actualMatches, 0, "Should show actual matches (0)")
    }

    func testFeature_AddTestCase_FromTemplate_CreatesTestCase() {
        // Given: a template available
        let template = TestCaseTemplate(name: "Email Template", testText: "test@example.com", expectedMatches: 1, shouldMatch: true)
        sut.availableTemplates = [template]

        // When: the user adds a test case from template
        sut.addTestCaseFromTemplate(template)

        // Then: a new test case should be created
        XCTAssertEqual(sut.testCases.count, 1, "Should have one test case")
        XCTAssertEqual(sut.testCases.first?.name, template.name, "Should use template name")
        XCTAssertEqual(sut.testCases.first?.testText, template.testText, "Should use template text")
    }

    func testFeature_ExportTestCases_ToJSON_GeneratesValidJSON() {
        // Given: test cases to export
        let testCases = [
            TestCase(name: "Test 1", testText: "123", expectedMatches: 1, shouldMatch: true),
            TestCase(name: "Test 2", testText: "abc", expectedMatches: 0, shouldMatch: false)
        ]
        sut.testCases = testCases

        // When: the user exports test cases
        sut.exportTestCases()

        // Then: JSON data should be generated
        XCTAssertTrue(mockService.exportTestCasesCalled, "Should call export test cases")
        // The mock service generates data in exportTestCases, so we check that exportedTestCases was set
        XCTAssertEqual(mockService.exportedTestCases.count, 2, "Should export both test cases")
        // Verify the service actually returned data by checking if it can be generated
        do {
            let data = try mockService.exportTestCases(testCases)
            XCTAssertNotNil(data, "Should generate export data")
            XCTAssertFalse(data.isEmpty, "Export data should not be empty")
        } catch {
            XCTFail("Export should not throw error: \(error)")
        }
    }

    func testFeature_ImportTestCases_FromJSON_LoadsTestCases() {
        // Given: JSON data representing test cases
        let testCases = [
            TestCase(name: "Imported 1", testText: "test1", expectedMatches: 1, shouldMatch: true),
            TestCase(name: "Imported 2", testText: "test2", expectedMatches: 0, shouldMatch: false)
        ]
        // Create valid JSON data for import
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        let exportableTestCases = testCases.map { ExportableTestCase(testCase: $0) }
        var jsonData: Data
        do {
            jsonData = try encoder.encode(exportableTestCases)
        } catch {
            XCTFail("Failed to encode test cases: \(error)")
            return
        }
        mockService.importedTestCases = testCases

        // When: the user imports test cases
        sut.importTestCases(from: jsonData)

        // Then: test cases should be loaded
        XCTAssertTrue(mockService.importTestCasesCalled, "Should call import test cases")
        XCTAssertEqual(sut.testCases.count, 2, "Should load both test cases")
    }

    // Helper struct for test
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
    }

    func testFeature_RunAllTests_WithInvalidPattern_ShowsError() {
        // Given: an invalid pattern
        let pattern = Pattern(name: "Invalid", pattern: "(")
        let testCase = TestCase(name: "Test", testText: "test", expectedMatches: 1, shouldMatch: true)
        sut.currentPattern = pattern
        sut.testCases = [testCase]
        mockRegexEngine.matchError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid pattern"])

        // When: the user runs all tests
        sut.runAllTests()

        // Then: the service should handle the error gracefully
        // The service catches errors and returns failed results, not an error
        XCTAssertTrue(mockService.runAllTestsCalled, "Should call run all tests")
        // The service returns a failed result for invalid patterns, not an error
        XCTAssertEqual(sut.testResults.count, 1, "Should have one result (failed)")
        XCTAssertFalse(sut.testResults.first?.passed ?? true, "Result should indicate failure")
    }
}
