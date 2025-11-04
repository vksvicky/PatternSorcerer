//
//  AppNavigationBDDTests.swift
//  PatternSorcererTests
//
//  BDD-style tests for app navigation functionality
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class AppNavigationBDDTests: XCTestCase {
    var sut: AppState!

    override func setUp() {
        super.setUp()
        sut = AppState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Feature: Navigation Commands

    func testFeature_NavigateToTutorials_FromMenu_SwitchesToTutorialsView() {
        // Given: user is on regex tester view
        sut.selectedFeature = .regexTester

        // When: user clicks "Learn Regex" in help menu
        sut.navigateToTutorials()

        // Then: tutorials view should be displayed
        XCTAssertEqual(sut.selectedFeature, .tutorials, "Should show tutorials view")
    }

    func testFeature_NavigateToRegexTester_FromMenu_SwitchesToRegexTesterView() {
        // Given: user is on code export view
        sut.selectedFeature = .codeExport

        // When: user clicks "Test Regex" in tools menu
        sut.navigateToRegexTester()

        // Then: regex tester view should be displayed
        XCTAssertEqual(sut.selectedFeature, .regexTester, "Should show regex tester view")
    }

    func testFeature_NavigateToCodeExport_FromMenu_SwitchesToCodeExportView() {
        // Given: user is on regex tester view
        sut.selectedFeature = .regexTester

        // When: user clicks "Export Code" in tools menu
        sut.navigateToCodeExport()

        // Then: code export view should be displayed
        XCTAssertEqual(sut.selectedFeature, .codeExport, "Should show code export view")
    }

    func testFeature_NavigateToPatternLibrary_FromMenu_SwitchesToPatternLibraryView() {
        // Given: user is on regex tester view
        sut.selectedFeature = .regexTester

        // When: user clicks "Open Pattern" in pattern menu
        sut.navigateToPatternLibrary()

        // Then: pattern library view should be displayed
        XCTAssertEqual(sut.selectedFeature, .patternLibrary, "Should show pattern library view")
    }
}
