//
//  RegexTesterViewModelTests.swift
//  PatternSorcererTests
//
//  Created on $(date)
//

import XCTest
import Combine
@testable import PatternSorcerer

@MainActor
final class RegexTesterViewModelTests: XCTestCase {
    var sut: RegexTesterViewModel!
    var mockRegexEngine: MockRegexEngine!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRegexEngine = MockRegexEngine()
        cancellables = Set<AnyCancellable>()
        sut = RegexTesterViewModel(regexEngine: mockRegexEngine)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        sut = nil
        mockRegexEngine = nil
        super.tearDown()
    }
    
    // MARK: - Pattern Validation Tests
    
    func testValidatePattern_ValidPattern_SetsIsValid() {
        // Given
        mockRegexEngine.validateResult = (true, nil)
        sut.pattern = "hello"
        
        // When
        sut.validatePattern()
        
        // Then
        XCTAssertTrue(sut.isPatternValid)
        XCTAssertNil(sut.validationError)
    }
    
    func testValidatePattern_InvalidPattern_SetsIsInvalid() {
        // Given
        mockRegexEngine.validateResult = (false, "Invalid pattern")
        sut.pattern = "[invalid"
        
        // When
        sut.validatePattern()
        
        // Then
        XCTAssertFalse(sut.isPatternValid)
        XCTAssertNotNil(sut.validationError)
    }
    
    // MARK: - Pattern Testing Tests
    
    func testTestPattern_ValidPattern_CallsRegexEngine() {
        // Given
        let expectedMatches = [
            MatchResult(range: NSRange(location: 0, length: 5), matchedText: "hello", captureGroups: [], matchNumber: 1)
        ]
        mockRegexEngine.matchResult = expectedMatches
        sut.pattern = "hello"
        sut.testText = "hello world"
        sut.isPatternValid = true
        
        // When
        sut.testPattern()
        
        // Then
        XCTAssertEqual(mockRegexEngine.matchCallCount, 1)
        XCTAssertEqual(sut.matches.count, 1)
    }
    
    func testTestPattern_InvalidPattern_DoesNotCallEngine() {
        // Given
        sut.pattern = "[invalid"
        sut.testText = "test"
        sut.isPatternValid = false
        
        // When
        sut.testPattern()
        
        // Then
        XCTAssertEqual(mockRegexEngine.matchCallCount, 0)
        XCTAssertEqual(sut.matches.count, 0)
    }
    
    // MARK: - Clear Tests
    
    func testClearPattern_ClearsPatternAndMatches() {
        // Given
        sut.pattern = "test"
        sut.matches = [MatchResult(range: NSRange(), matchedText: "test", matchNumber: 1)]
        
        // When
        sut.clearPattern()
        
        // Then
        XCTAssertTrue(sut.pattern.isEmpty)
        XCTAssertTrue(sut.matches.isEmpty)
        XCTAssertNil(sut.validationError)
    }
    
    func testClearTestText_ClearsTestText() {
        // Given
        sut.testText = "test text"
        
        // When
        sut.clearTestText()
        
        // Then
        XCTAssertTrue(sut.testText.isEmpty)
    }
}

// MARK: - Mock Regex Engine

class MockRegexEngine: RegexEngine {
    var matchResult: [MatchResult] = []
    var matchCallCount = 0
    var replaceResult: String = ""
    var replaceCallCount = 0
    var splitResult: [String] = []
    var splitCallCount = 0
    var validateResult: (isValid: Bool, error: String?) = (true, nil)
    
    override func match(pattern: String, in text: String, options: NSRegularExpression.Options = []) throws -> [MatchResult] {
        matchCallCount += 1
        return matchResult
    }
    
    override func replace(pattern: String, in text: String, with replacement: String, options: NSRegularExpression.Options = []) throws -> String {
        replaceCallCount += 1
        return replaceResult
    }
    
    override func split(pattern: String, in text: String, options: NSRegularExpression.Options = []) throws -> [String] {
        splitCallCount += 1
        return splitResult
    }
    
    override func validatePattern(_ pattern: String) -> (isValid: Bool, error: String?) {
        return validateResult
    }
}

