//
//  PatternExportImportBDDTests.swift
//  PatternSorcererTests
//
//  BDD-style tests for pattern export/import functionality
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class PatternExportImportBDDTests: XCTestCase {
    var sut: PatternExportImportService!
    var mockService: MockPatternExportImportService!

    override func setUp() {
        super.setUp()
        sut = PatternExportImportService()
        mockService = MockPatternExportImportService()
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Feature: Export Patterns

    func testFeature_ExportPatterns_ToFile_SavesPatterns() throws {
        // Given: user has patterns to export
        let patterns = [
            Pattern(name: "Email", pattern: "[a-z]+@[a-z]+")
        ]
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test_export.json")

        // When: user exports patterns to file
        try sut.exportPatternsToFile(patterns, url: tempURL)

        // Then: file should exist and contain patterns
        XCTAssertTrue(FileManager.default.fileExists(atPath: tempURL.path), "File should be created")
        let imported = try sut.importPatternsFromFile(url: tempURL)
        XCTAssertEqual(imported.count, 1, "Should be able to import exported patterns")

        // Cleanup
        try? FileManager.default.removeItem(at: tempURL)
    }

    func testFeature_ImportPatterns_FromFile_LoadsPatterns() throws {
        // Given: user has an exported patterns file
        let patterns = [
            Pattern(name: "Test", pattern: "test")
        ]
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test_import.json")
        try sut.exportPatternsToFile(patterns, url: tempURL)

        // When: user imports patterns from file
        let imported = try sut.importPatternsFromFile(url: tempURL)

        // Then: patterns should be loaded
        XCTAssertEqual(imported.count, 1, "Should import patterns")
        XCTAssertEqual(imported.first?.name, "Test", "Should preserve pattern name")

        // Cleanup
        try? FileManager.default.removeItem(at: tempURL)
    }

    func testFeature_ExportImport_MultiplePatterns_PreservesAll() throws {
        // Given: user has multiple patterns
        let patterns = [
            Pattern(name: "Pattern 1", pattern: "pattern1"),
            Pattern(name: "Pattern 2", pattern: "pattern2"),
            Pattern(name: "Pattern 3", pattern: "pattern3")
        ]

        // When: user exports and imports
        let data = try sut.exportPatterns(patterns)
        let imported = try sut.importPatterns(from: data)

        // Then: all patterns should be preserved
        XCTAssertEqual(imported.count, 3, "Should preserve all patterns")
        XCTAssertEqual(imported.map { $0.name }, ["Pattern 1", "Pattern 2", "Pattern 3"], "Should preserve order and names")
    }
}
