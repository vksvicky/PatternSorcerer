//
//  TestSuiteManagerViewModel.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Combine
import Foundation
import SwiftData

@MainActor
class TestSuiteManagerViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var currentPattern: Pattern?
    @Published var testCases: [TestCase] = []
    @Published var testResults: [TestCaseResult] = []
    @Published var availableTemplates: [TestCaseTemplate] = []
    @Published var error: String?
    @Published var isLoading = false

    // MARK: - Private Properties

    private let testSuiteService: TestSuiteServiceProtocol
    private let regexEngine: RegexEngineProtocol

    // MARK: - Initialization

    init(
        testSuiteService: TestSuiteServiceProtocol = TestSuiteService(),
        regexEngine: RegexEngineProtocol = RegexEngine()
    ) {
        self.testSuiteService = testSuiteService
        self.regexEngine = regexEngine
        loadTemplates()
    }

    // MARK: - Public Methods

    func loadTestCases(for pattern: Pattern) {
        currentPattern = pattern
        testCases = pattern.testCases
        testResults = []
        error = nil
        Logger.debug("Loaded \(testCases.count) test cases for pattern: \(pattern.name)")
    }

    func addTestCase(_ testCase: TestCase) {
        testCases.append(testCase)
        Logger.debug("Added test case: \(testCase.name)")
    }

    func removeTestCase(at index: Int) {
        guard index < testCases.count else { return }
        let removed = testCases.remove(at: index)
        Logger.debug("Removed test case: \(removed.name)")
    }

    func addTestCaseFromTemplate(_ template: TestCaseTemplate) {
        let testCase = template.toTestCase()
        addTestCase(testCase)
    }

    func saveTestCases() {
        guard let pattern = currentPattern else {
            error = "No pattern selected"
            return
        }

        do {
            try testSuiteService.saveTestCases(testCases, for: pattern)
            pattern.testCases = testCases
            error = nil
            Logger.info("Successfully saved \(testCases.count) test cases")
        } catch {
            self.error = "Failed to save test cases: \(error.localizedDescription)"
            Logger.error("Failed to save test cases: \(error.localizedDescription)")
        }
    }

    func runAllTests() {
        guard let pattern = currentPattern else {
            error = "No pattern selected"
            return
        }

        guard !testCases.isEmpty else {
            error = "No test cases to run"
            return
        }

        isLoading = true
        error = nil

        do {
            let results = try testSuiteService.runAllTests(
                pattern: pattern,
                testCases: testCases,
                regexEngine: regexEngine
            )
            testResults = results
            Logger.info("Ran \(testCases.count) test cases, \(results.filter { $0.passed }.count) passed")
        } catch {
            self.error = "Failed to run tests: \(error.localizedDescription)"
            Logger.error("Failed to run tests: \(error.localizedDescription)")
            testResults = []
        }

        isLoading = false
    }

    func exportTestCases() {
        guard !testCases.isEmpty else {
            error = "No test cases to export"
            return
        }

        do {
            _ = try testSuiteService.exportTestCases(testCases)
            // In a real implementation, this would show a save panel
            Logger.info("Exported \(testCases.count) test cases")
            error = nil
        } catch {
            self.error = "Failed to export test cases: \(error.localizedDescription)"
            Logger.error("Failed to export test cases: \(error.localizedDescription)")
        }
    }

    func importTestCases(from data: Data) {
        do {
            let imported = try testSuiteService.importTestCases(from: data)
            testCases.append(contentsOf: imported)
            Logger.info("Imported \(imported.count) test cases")
            error = nil
        } catch {
            self.error = "Failed to import test cases: \(error.localizedDescription)"
            Logger.error("Failed to import test cases: \(error.localizedDescription)")
        }
    }

    func clearResults() {
        testResults = []
        error = nil
    }

    // MARK: - Private Methods

    private func loadTemplates() {
        availableTemplates = testSuiteService.getTemplates()
        Logger.debug("Loaded \(availableTemplates.count) templates")
    }
}
