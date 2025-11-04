//
//  PatternExportImportServiceTests.swift
//  PatternSorcererTests
//
//  Unit tests for PatternExportImportService
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

final class PatternExportImportServiceTests: XCTestCase {
    var sut: PatternExportImportService!

    override func setUp() {
        super.setUp()
        sut = PatternExportImportService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Export Tests

    func testExportPatterns_WithValidPatterns_ReturnsData() throws {
        // Given
        let patterns = [
            Pattern(name: "Test Pattern", pattern: "test", patternDescription: "Test")
        ]

        // When
        let data = try sut.exportPatterns(patterns)

        // Then
        XCTAssertFalse(data.isEmpty, "Should return non-empty data")
    }

    func testExportPatterns_WithMultiplePatterns_ExportsAll() throws {
        // Given
        let patterns = [
            Pattern(name: "Pattern 1", pattern: "pattern1"),
            Pattern(name: "Pattern 2", pattern: "pattern2")
        ]

        // When
        let data = try sut.exportPatterns(patterns)

        // Then
        let imported = try sut.importPatterns(from: data)
        XCTAssertEqual(imported.count, 2, "Should export all patterns")
    }

    // MARK: - Import Tests

    func testImportPatterns_WithValidData_ReturnsPatterns() throws {
        // Given
        let patterns = [
            Pattern(name: "Test Pattern", pattern: "test")
        ]
        let data = try sut.exportPatterns(patterns)

        // When
        let imported = try sut.importPatterns(from: data)

        // Then
        XCTAssertEqual(imported.count, 1, "Should import pattern")
        XCTAssertEqual(imported.first?.name, "Test Pattern", "Should preserve name")
        XCTAssertEqual(imported.first?.pattern, "test", "Should preserve pattern")
    }

    func testImportPatterns_WithInvalidData_ThrowsError() {
        // Given
        let invalidData = Data("invalid json".utf8)

        // When & Then
        XCTAssertThrowsError(try sut.importPatterns(from: invalidData), "Should throw error for invalid data")
    }

    // MARK: - Round Trip Tests

    func testExportImport_RoundTrip_PreservesData() throws {
        // Given
        let originalPattern = Pattern(
            name: "Email Pattern",
            pattern: "[a-z]+@[a-z]+\\.[a-z]+",
            patternDescription: "Email regex",
            category: .email,
            tags: ["email", "validation"]
        )

        // When
        let data = try sut.exportPatterns([originalPattern])
        let imported = try sut.importPatterns(from: data)

        // Then
        XCTAssertEqual(imported.count, 1, "Should import one pattern")
        let importedPattern = imported.first!
        XCTAssertEqual(importedPattern.name, originalPattern.name, "Should preserve name")
        XCTAssertEqual(importedPattern.pattern, originalPattern.pattern, "Should preserve pattern")
        XCTAssertEqual(importedPattern.patternDescription, originalPattern.patternDescription, "Should preserve description")
        XCTAssertEqual(importedPattern.category, originalPattern.category, "Should preserve category")
        XCTAssertEqual(importedPattern.tags, originalPattern.tags, "Should preserve tags")
    }
}
