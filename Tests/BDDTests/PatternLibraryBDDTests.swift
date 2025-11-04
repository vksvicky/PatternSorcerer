//
//  PatternLibraryBDDTests.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class PatternLibraryBDDTests: XCTestCase {
    var sut: PatternLibraryViewModel!
    var mockService: MockPatternLibraryService!

    override func setUp() {
        super.setUp()
        mockService = MockPatternLibraryService()
        sut = PatternLibraryViewModel(patternLibraryService: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Feature: Browse Pattern Library

    func testFeature_BrowsePatternLibrary_ShowsCommonPatterns() {
        // Given: a pattern library with common patterns
        let patterns = [
            Pattern(name: "Email", pattern: "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b", category: .email),
            Pattern(name: "URL", pattern: "https?://[^\\s]+", category: .url),
            Pattern(name: "Phone", pattern: "\\d{3}-\\d{3}-\\d{4}", category: .phone)
        ]
        mockService.commonPatterns = patterns

        // When: the user opens the pattern library
        sut.loadPatterns()

        // Then: common patterns should be displayed
        XCTAssertTrue(mockService.loadCommonPatternsCalled, "Should load common patterns")
        XCTAssertEqual(sut.patterns.count, 3, "Should show 3 patterns")
        XCTAssertEqual(sut.patterns.first?.name, "Email", "Should show email pattern first")
    }

    func testFeature_FilterPatterns_ByCategory_ShowsFilteredResults() {
        // Given: patterns in different categories
        let emailPattern = Pattern(name: "Email", pattern: "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b", category: .email)
        let urlPattern = Pattern(name: "URL", pattern: "https?://[^\\s]+", category: .url)
        mockService.commonPatterns = [emailPattern, urlPattern]
        sut.loadPatterns()

        // When: the user filters by email category
        sut.selectedCategory = .email

        // Then: only email patterns should be shown
        XCTAssertEqual(sut.filteredPatterns.count, 1, "Should show only email patterns")
        XCTAssertEqual(sut.filteredPatterns.first?.category, .email, "Should be email category")
    }

    func testFeature_SearchPatterns_ByName_FindsMatchingPatterns() {
        // Given: patterns with different names
        let patterns = [
            Pattern(name: "Email Validator", pattern: "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b", category: .email),
            Pattern(name: "URL Parser", pattern: "https?://[^\\s]+", category: .url),
            Pattern(name: "Phone Number", pattern: "\\d{3}-\\d{3}-\\d{4}", category: .phone)
        ]
        mockService.commonPatterns = patterns
        sut.loadPatterns()

        // When: the user searches for "email"
        sut.searchText = "email"

        // Then: only matching patterns should be shown
        XCTAssertEqual(sut.filteredPatterns.count, 1, "Should find one matching pattern")
        XCTAssertTrue(sut.filteredPatterns.first?.name.lowercased().contains("email") ?? false, "Should match email pattern")
    }

    func testFeature_SearchPatterns_ByPattern_FindsMatchingPatterns() {
        // Given: patterns with different regex patterns
        let patterns = [
            Pattern(name: "Email", pattern: "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b", category: .email),
            Pattern(name: "URL", pattern: "https?://[^\\s]+", category: .url),
            Pattern(name: "Digits", pattern: "\\d+", category: .general)
        ]
        mockService.commonPatterns = patterns
        sut.loadPatterns()

        // When: the user searches for "\\d"
        sut.searchText = "\\d"

        // Then: patterns containing \\d should be shown
        let matchingPatterns = sut.filteredPatterns.filter { $0.pattern.contains("\\d") }
        XCTAssertGreaterThan(matchingPatterns.count, 0, "Should find patterns with \\d")
    }

    func testFeature_SelectPattern_CopiesToClipboard() {
        // Given: a pattern in the library
        let pattern = Pattern(name: "Email", pattern: "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b", category: .email)
        mockService.commonPatterns = [pattern]
        sut.loadPatterns()

        // When: the user selects a pattern
        sut.selectPattern(pattern)

        // Then: the pattern should be copied
        XCTAssertTrue(mockService.copyPatternCalled, "Should copy pattern")
        XCTAssertEqual(mockService.copiedPattern?.id, pattern.id, "Should copy correct pattern")
    }

    func testFeature_ViewPatternDetails_ShowsFullInformation() {
        // Given: a pattern with description
        let pattern = Pattern(
            name: "Email Validator",
            pattern: "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b",
            patternDescription: "Validates email addresses",
            category: .email,
            tags: ["email", "validation"]
        )
        mockService.commonPatterns = [pattern]
        sut.loadPatterns()

        // When: the user views pattern details
        sut.selectedPattern = pattern

        // Then: full pattern information should be available
        XCTAssertNotNil(sut.selectedPattern, "Should have selected pattern")
        XCTAssertEqual(sut.selectedPattern?.name, "Email Validator", "Should show name")
        XCTAssertEqual(sut.selectedPattern?.patternDescription, "Validates email addresses", "Should show description")
        XCTAssertEqual(sut.selectedPattern?.tags.count, 2, "Should show tags")
    }

    // MARK: - Feature: Character Class Reference

    func testFeature_ViewCharacterClassReference_ShowsCommonClasses() {
        // Given: character class reference is available
        // When: the user views the character class reference
        let characterClasses = sut.characterClassReference

        // Then: common character classes should be displayed
        XCTAssertFalse(characterClasses.isEmpty, "Should have character classes")
        XCTAssertNotNil(characterClasses.first(where: { $0.symbol == "\\d" }), "Should include \\d")
        XCTAssertNotNil(characterClasses.first(where: { $0.symbol == "\\w" }), "Should include \\w")
    }

    // MARK: - Feature: Quantifier Cheat Sheet

    func testFeature_ViewQuantifierCheatSheet_ShowsCommonQuantifiers() {
        // Given: quantifier cheat sheet is available
        // When: the user views the quantifier cheat sheet
        let quantifiers = sut.quantifierCheatSheet

        // Then: common quantifiers should be displayed
        XCTAssertFalse(quantifiers.isEmpty, "Should have quantifiers")
        XCTAssertNotNil(quantifiers.first(where: { $0.symbol == "*" }), "Should include *")
        XCTAssertNotNil(quantifiers.first(where: { $0.symbol == "+" }), "Should include +")
        XCTAssertNotNil(quantifiers.first(where: { $0.symbol == "?" }), "Should include ?")
    }
}
