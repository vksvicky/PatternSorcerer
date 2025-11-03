//
//  PatternComplexityAnalyzerTests.swift
//  PatternSorcererTests
//
//  TDD Tests for Pattern Complexity Analyzer
//
//  Created on $(date)
//

import XCTest
@testable import PatternSorcerer

final class PatternComplexityAnalyzerTests: XCTestCase {
    var sut: PatternComplexityAnalyzer!
    
    override func setUp() {
        super.setUp()
        sut = PatternComplexityAnalyzer()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Complexity Score Tests
    
    func testCalculateComplexity_SimplePattern_ReturnsLowScore() {
        // Given
        let pattern = "hello"
        
        // When
        let score = sut.calculateComplexity(pattern)
        
        // Then
        XCTAssertLessThan(score.score, 30, "Simple pattern should have low complexity")
        XCTAssertEqual(score.level, .simple)
    }
    
    func testCalculateComplexity_ComplexPattern_ReturnsHighScore() {
        // Given
        let pattern = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}"
        
        // When
        let score = sut.calculateComplexity(pattern)
        
        // Then
        XCTAssertGreaterThan(score.score, 60, "Complex pattern should have high complexity")
        XCTAssertTrue(score.level == .complex || score.level == .veryComplex)
    }
    
    func testCalculateComplexity_WithLookaround_DetectsLookaroundFactor() {
        // Given
        let pattern = "(?=positive)"
        
        // When
        let score = sut.calculateComplexity(pattern)
        
        // Then
        XCTAssertTrue(score.factors.contains(.lookaround), "Should detect lookaround")
    }
    
    func testCalculateComplexity_WithManyGroups_DetectsManyGroupsFactor() {
        // Given
        let pattern = "(a)(b)(c)(d)(e)(f)"
        
        // When
        let score = sut.calculateComplexity(pattern)
        
        // Then
        XCTAssertTrue(score.factors.contains(.manyGroups), "Should detect many groups")
    }
    
    func testCalculateComplexity_WithManyAlternations_DetectsManyAlternationsFactor() {
        // Given
        let pattern = "a|b|c|d|e|f|g"
        
        // When
        let score = sut.calculateComplexity(pattern)
        
        // Then
        XCTAssertTrue(score.factors.contains(.manyAlternations), "Should detect many alternations")
    }
    
    func testCalculateComplexity_VeryLongPattern_DetectsVeryLongFactor() {
        // Given
        let pattern = String(repeating: "a", count: 250)
        
        // When
        let score = sut.calculateComplexity(pattern)
        
        // Then
        XCTAssertTrue(score.factors.contains(.veryLong), "Should detect very long pattern")
    }
    
    // MARK: - Optimization Suggestions Tests
    
    func testGetOptimizationSuggestions_WithManyAlternations_SuggestsCharacterClass() {
        // Given
        let pattern = "a|b|c|d|e"
        
        // When
        let suggestions = sut.getOptimizationSuggestions(pattern)
        
        // Then
        XCTAssertTrue(suggestions.contains(.considerCharacterClass), "Should suggest character class")
    }
    
    func testGetOptimizationSuggestions_WithManyGroups_SuggestsNonCapturing() {
        // Given
        let pattern = "(a)(b)(c)(d)(e)"
        
        // When
        let suggestions = sut.getOptimizationSuggestions(pattern)
        
        // Then
        XCTAssertTrue(suggestions.contains(.useNonCapturingGroups), "Should suggest non-capturing groups")
    }
    
    func testGetOptimizationSuggestions_WithDotStar_SuggestsSpecificPattern() {
        // Given
        let pattern = ".*"
        
        // When
        let suggestions = sut.getOptimizationSuggestions(pattern)
        
        // Then
        XCTAssertTrue(suggestions.contains(.useMoreSpecificPattern), "Should suggest more specific pattern")
    }
    
    func testGetOptimizationSuggestions_VeryLong_SuggestsBreakIntoMultiple() {
        // Given
        let pattern = String(repeating: "a", count: 250)
        
        // When
        let suggestions = sut.getOptimizationSuggestions(pattern)
        
        // Then
        XCTAssertTrue(suggestions.contains(.breakIntoMultiplePatterns), "Should suggest breaking into multiple patterns")
    }
}

