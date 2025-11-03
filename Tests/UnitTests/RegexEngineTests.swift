//
//  RegexEngineTests.swift
//  PatternSorcererTests
//
//  Created on $(date)
//

import XCTest
@testable import PatternSorcerer

final class RegexEngineTests: XCTestCase {
    var sut: RegexEngine!
    
    override func setUp() {
        super.setUp()
        sut = RegexEngine()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Match Tests
    
    func testMatch_SimplePattern_ReturnsMatches() {
        // Given
        let pattern = "hello"
        let text = "hello world hello"
        
        // When
        let matches = try? sut.match(pattern: pattern, in: text)
        
        // Then
        XCTAssertNotNil(matches)
        XCTAssertEqual(matches?.count, 2)
        XCTAssertEqual(matches?.first?.matchedText, "hello")
    }
    
    func testMatch_NoMatches_ReturnsEmptyArray() {
        // Given
        let pattern = "xyz"
        let text = "hello world"
        
        // When
        let matches = try? sut.match(pattern: pattern, in: text)
        
        // Then
        XCTAssertNotNil(matches)
        XCTAssertEqual(matches?.count, 0)
    }
    
    func testMatch_CaptureGroups_ExtractsGroups() {
        // Given
        let pattern = "(\\d+)-(\\d+)"
        let text = "123-456"
        
        // When
        let matches = try? sut.match(pattern: pattern, in: text)
        
        // Then
        XCTAssertNotNil(matches)
        XCTAssertEqual(matches?.count, 1)
        XCTAssertEqual(matches?.first?.captureGroups.count, 2)
        XCTAssertEqual(matches?.first?.captureGroups[0].text, "123")
        XCTAssertEqual(matches?.first?.captureGroups[1].text, "456")
    }
    
    func testMatch_InvalidPattern_ThrowsError() {
        // Given
        let pattern = "[invalid"
        let text = "test"
        
        // When & Then
        XCTAssertThrowsError(try sut.match(pattern: pattern, in: text)) { error in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Replace Tests
    
    func testReplace_SimplePattern_ReplacesMatches() {
        // Given
        let pattern = "hello"
        let text = "hello world"
        let replacement = "hi"
        
        // When
        let result = try? sut.replace(pattern: pattern, in: text, with: replacement)
        
        // Then
        XCTAssertEqual(result, "hi world")
    }
    
    func testReplace_WithCaptureGroups_ReplacesWithGroups() {
        // Given
        let pattern = "(\\d+)-(\\d+)"
        let text = "123-456"
        let replacement = "$2-$1"
        
        // When
        let result = try? sut.replace(pattern: pattern, in: text, with: replacement)
        
        // Then
        XCTAssertEqual(result, "456-123")
    }
    
    // MARK: - Split Tests
    
    func testSplit_ByPattern_SplitsText() {
        // Given
        let pattern = "\\s+"
        let text = "hello world test"
        
        // When
        let results = try? sut.split(pattern: pattern, in: text)
        
        // Then
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 3)
        XCTAssertEqual(results?[0], "hello")
        XCTAssertEqual(results?[1], "world")
        XCTAssertEqual(results?[2], "test")
    }
    
    // MARK: - Validation Tests
    
    func testValidatePattern_ValidPattern_ReturnsTrue() {
        // Given
        let pattern = "hello"
        
        // When
        let result = sut.validatePattern(pattern)
        
        // Then
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.error)
    }
    
    func testValidatePattern_InvalidPattern_ReturnsFalse() {
        // Given
        let pattern = "[invalid"
        
        // When
        let result = sut.validatePattern(pattern)
        
        // Then
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.error)
    }
}

