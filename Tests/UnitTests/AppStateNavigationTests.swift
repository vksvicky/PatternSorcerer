//
//  AppStateNavigationTests.swift
//  PatternSorcererTests
//
//  Unit tests for AppState navigation functionality
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

final class AppStateNavigationTests: XCTestCase {
    var sut: AppState!

    override func setUp() {
        super.setUp()
        sut = AppState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Feature Navigation

    func testNavigateToTutorials_SetsSelectedFeatureToTutorials() {
        // Given
        sut.selectedFeature = .regexTester

        // When
        sut.navigateToTutorials()

        // Then
        XCTAssertEqual(sut.selectedFeature, .tutorials, "Should navigate to tutorials")
    }

    func testNavigateToRegexTester_SetsSelectedFeatureToRegexTester() {
        // Given
        sut.selectedFeature = .tutorials

        // When
        sut.navigateToRegexTester()

        // Then
        XCTAssertEqual(sut.selectedFeature, .regexTester, "Should navigate to regex tester")
    }

    func testNavigateToCodeExport_SetsSelectedFeatureToCodeExport() {
        // Given
        sut.selectedFeature = .regexTester

        // When
        sut.navigateToCodeExport()

        // Then
        XCTAssertEqual(sut.selectedFeature, .codeExport, "Should navigate to code export")
    }

    func testNavigateToPatternLibrary_SetsSelectedFeatureToPatternLibrary() {
        // Given
        sut.selectedFeature = .regexTester

        // When
        sut.navigateToPatternLibrary()

        // Then
        XCTAssertEqual(sut.selectedFeature, .patternLibrary, "Should navigate to pattern library")
    }
}
