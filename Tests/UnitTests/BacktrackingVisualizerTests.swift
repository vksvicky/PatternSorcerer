//
//  BacktrackingVisualizerTests.swift
//  PatternSorcererTests
//
//  Unit tests for BacktrackingVisualizer
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

final class BacktrackingVisualizerTests: XCTestCase {
    var sut: BacktrackingVisualizer!

    override func setUp() {
        super.setUp()
        sut = BacktrackingVisualizer()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Catastrophic Backtracking Tests

    func testAnalyzeBacktracking_CatastrophicPattern_DetectsWarning() {
        // Given
        let pattern = ".*.*"
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertTrue(
            analysis.warnings.contains(.catastrophicBacktracking),
            "Should detect catastrophic backtracking"
        )
        XCTAssertEqual(analysis.riskLevel, .high, "Should have high risk level")
    }

    func testAnalyzeBacktracking_DotPlusDotStar_DetectsWarning() {
        // Given
        let pattern = ".+.*"
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertTrue(
            analysis.warnings.contains(.catastrophicBacktracking),
            "Should detect catastrophic backtracking"
        )
    }

    // MARK: - Nested Quantifier Tests

    func testAnalyzeBacktracking_NestedQuantifiers_DetectsWarning() {
        // Given
        let pattern = "(.*)+"
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertTrue(
            analysis.warnings.contains(.nestedQuantifiers),
            "Should detect nested quantifiers"
        )
        XCTAssertEqual(analysis.riskLevel, .medium, "Should have medium risk level")
    }

    func testAnalyzeBacktracking_PlusStar_DetectsWarning() {
        // Given
        let pattern = "(.+)*"
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertTrue(
            analysis.warnings.contains(.nestedQuantifiers),
            "Should detect nested quantifiers"
        )
    }

    // MARK: - Quantified Alternation Tests

    func testAnalyzeBacktracking_QuantifiedAlternation_DetectsWarning() {
        // Given
        let pattern = "(a|b)*"
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertTrue(
            analysis.warnings.contains(.quantifiedAlternation),
            "Should detect quantified alternation"
        )
    }

    // MARK: - Inefficient Pattern Tests

    func testAnalyzeBacktracking_LongPattern_DetectsWarning() {
        // Given
        let pattern = String(repeating: "a", count: 100)
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertTrue(
            analysis.warnings.contains(.inefficientPattern),
            "Should detect inefficient pattern"
        )
    }

    // MARK: - Risk Level Tests

    func testAnalyzeBacktracking_LowRisk_ReturnsLowLevel() {
        // Given
        let pattern = "hello"
        let text = "hello world"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertEqual(analysis.riskLevel, .low, "Simple pattern should have low risk")
        XCTAssertTrue(analysis.warnings.isEmpty, "Should have no warnings")
    }

    func testAnalyzeBacktracking_MediumRisk_ReturnsMediumLevel() {
        // Given
        let pattern = "(.*)+"
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertEqual(analysis.riskLevel, .medium, "Should have medium risk")
    }

    func testAnalyzeBacktracking_HighRisk_ReturnsHighLevel() {
        // Given
        let pattern = ".*.*"
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertEqual(analysis.riskLevel, .high, "Should have high risk")
    }

    // MARK: - Suggestions Tests

    func testAnalyzeBacktracking_CatastrophicBacktracking_ProvidesSuggestions() {
        // Given
        let pattern = ".*.*"
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertFalse(analysis.suggestions.isEmpty, "Should provide suggestions")
        XCTAssertTrue(
            analysis.suggestions.contains { $0.contains("possessive") || $0.contains("atomic") },
            "Should suggest possessive quantifiers or atomic groups"
        )
    }

    func testAnalyzeBacktracking_NestedQuantifiers_ProvidesSuggestions() {
        // Given
        let pattern = "(.*)+"
        let text = "test"

        // When
        let analysis = sut.analyzeBacktracking(pattern: pattern, text: text)

        // Then
        XCTAssertFalse(analysis.suggestions.isEmpty, "Should provide suggestions")
    }
}
