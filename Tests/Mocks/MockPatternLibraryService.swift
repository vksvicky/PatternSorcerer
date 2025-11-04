//
//  MockPatternLibraryService.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

import Foundation
@testable import PatternSorcerer

class MockPatternLibraryService: PatternLibraryServiceProtocol {
    var loadCommonPatternsCalled = false
    var commonPatterns: [Pattern] = []

    var copyPatternCalled = false
    var copiedPattern: Pattern?

    var searchPatternsCalled = false
    var searchQuery: String?
    var searchResults: [Pattern] = []

    var filterPatternsCalled = false
    var filterCategory: PatternCategory?
    var filterResults: [Pattern] = []

    func loadCommonPatterns() -> [Pattern] {
        loadCommonPatternsCalled = true
        return commonPatterns
    }

    func copyPattern(_ pattern: Pattern) {
        copyPatternCalled = true
        copiedPattern = pattern
    }

    func searchPatterns(_ query: String, in patterns: [Pattern]) -> [Pattern] {
        searchPatternsCalled = true
        searchQuery = query
        let lowercasedQuery = query.lowercased()
        return patterns.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.pattern.contains(query) ||
            $0.patternDescription.lowercased().contains(lowercasedQuery) ||
            $0.tags.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }

    func filterPatterns(_ patterns: [Pattern], by category: PatternCategory?) -> [Pattern] {
        filterPatternsCalled = true
        filterCategory = category
        guard let category = category else {
            return patterns
        }
        return patterns.filter { $0.category == category }
    }
}
