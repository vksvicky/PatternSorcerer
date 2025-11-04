//
//  PatternModelTests.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

final class PatternModelTests: XCTestCase {

    func testPattern_Initialization_CreatesPattern() {
        // Given & When
        let pattern = Pattern(
            name: "Test Pattern",
            pattern: "\\d+",
            patternDescription: "Matches digits",
            category: .general,
            tags: ["test", "numbers"]
        )

        // Then
        XCTAssertEqual(pattern.name, "Test Pattern")
        XCTAssertEqual(pattern.pattern, "\\d+")
        XCTAssertEqual(pattern.patternDescription, "Matches digits")
        XCTAssertEqual(pattern.category, .general)
        XCTAssertEqual(pattern.tags.count, 2)
    }

    func testPattern_DefaultValues_UsesDefaults() {
        // Given & When
        let pattern = Pattern(name: "Test", pattern: "test")

        // Then
        XCTAssertEqual(pattern.patternDescription, "")
        XCTAssertEqual(pattern.category, .general)
        XCTAssertTrue(pattern.tags.isEmpty)
        XCTAssertTrue(pattern.testCases.isEmpty)
    }
}
