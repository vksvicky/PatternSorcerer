//
//  RegexTesterBDDTests.swift
//  PatternSorcererTests
//
//  BDD-style tests using Gherkin-like structure
//
//  Created on $(date)
//

import XCTest
@testable import PatternSorcerer

@MainActor
final class RegexTesterBDDTests: XCTestCase {
    var sut: RegexTesterViewModel!
    var regexEngine: RegexEngine!
    
    override func setUp() {
        super.setUp()
        regexEngine = RegexEngine()
        sut = RegexTesterViewModel(regexEngine: regexEngine)
    }
    
    override func tearDown() {
        sut = nil
        regexEngine = nil
        super.tearDown()
    }
    
    // MARK: - Feature: Pattern Validation
    
    func testFeature_PatternValidation_ValidPattern() {
        // Given: the user enters a valid regex pattern
        let pattern = "hello"
        
        // When: the pattern is validated
        sut.pattern = pattern
        sut.validatePattern()
        
        // Then: the pattern should be marked as valid
        XCTAssertTrue(sut.isPatternValid, "Pattern should be valid")
        XCTAssertNil(sut.validationError, "No error should be present")
    }
    
    func testFeature_PatternValidation_InvalidPattern() {
        // Given: the user enters an invalid regex pattern
        let pattern = "[invalid"
        
        // When: the pattern is validated
        sut.pattern = pattern
        sut.validatePattern()
        
        // Then: the pattern should be marked as invalid with an error message
        XCTAssertFalse(sut.isPatternValid, "Pattern should be invalid")
        XCTAssertNotNil(sut.validationError, "Error message should be present")
    }
    
    // MARK: - Feature: Pattern Matching
    
    func testFeature_PatternMatching_SingleMatch() {
        // Given: a valid pattern and test text with one match
        sut.pattern = "hello"
        sut.testText = "hello world"
        sut.isPatternValid = true
        
        // When: the pattern is tested
        sut.testPattern()
        
        // Then: one match should be found
        XCTAssertEqual(sut.matches.count, 1, "Should find one match")
        XCTAssertEqual(sut.matches.first?.matchedText, "hello", "Match text should be 'hello'")
    }
    
    func testFeature_PatternMatching_MultipleMatches() {
        // Given: a valid pattern and test text with multiple matches
        sut.pattern = "hello"
        sut.testText = "hello world hello"
        sut.isPatternValid = true
        
        // When: the pattern is tested
        sut.testPattern()
        
        // Then: multiple matches should be found
        XCTAssertEqual(sut.matches.count, 2, "Should find two matches")
    }
    
    func testFeature_PatternMatching_CaptureGroups() {
        // Given: a pattern with capture groups and matching text
        sut.pattern = "(\\d+)-(\\d+)"
        sut.testText = "123-456"
        sut.isPatternValid = true
        
        // When: the pattern is tested
        sut.testPattern()
        
        // Then: capture groups should be extracted
        XCTAssertEqual(sut.matches.count, 1, "Should find one match")
        let match = sut.matches.first!
        XCTAssertEqual(match.captureGroups.count, 2, "Should have two capture groups")
        XCTAssertEqual(match.captureGroups[0].text, "123", "First group should be '123'")
        XCTAssertEqual(match.captureGroups[1].text, "456", "Second group should be '456'")
    }
    
    // MARK: - Feature: Pattern Clearing
    
    func testFeature_PatternClearing_ClearsPatternAndMatches() {
        // Given: a pattern with matches
        sut.pattern = "hello"
        sut.testText = "hello world"
        sut.testPattern()
        XCTAssertFalse(sut.matches.isEmpty, "Should have matches before clearing")
        
        // When: the pattern is cleared
        sut.clearPattern()
        
        // Then: pattern and matches should be cleared
        XCTAssertTrue(sut.pattern.isEmpty, "Pattern should be empty")
        XCTAssertTrue(sut.matches.isEmpty, "Matches should be empty")
        XCTAssertNil(sut.validationError, "Error should be nil")
    }
}

