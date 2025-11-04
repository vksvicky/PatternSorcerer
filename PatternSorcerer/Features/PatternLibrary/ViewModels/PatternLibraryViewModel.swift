//
//  PatternLibraryViewModel.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation
import SwiftUI

@MainActor
final class PatternLibraryViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var patterns: [Pattern] = []
    @Published var selectedPattern: Pattern?
    @Published var selectedCategory: PatternCategory?
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var error: String?

    // MARK: - Computed Properties

    var filteredPatterns: [Pattern] {
        var result = patterns

        // Apply category filter
        if let category = selectedCategory {
            result = patternLibraryService.filterPatterns(result, by: category)
        }

        // Apply search filter
        if !searchText.isEmpty {
            result = patternLibraryService.searchPatterns(searchText, in: result)
        }

        return result
    }

    var characterClassReference: [CharacterClassReference] {
        CharacterClassReference.common
    }

    var quantifierCheatSheet: [QuantifierCheatSheet] {
        QuantifierCheatSheet.common
    }

    // MARK: - Private Properties

    private let patternLibraryService: PatternLibraryServiceProtocol

    // MARK: - Initialization

    init(patternLibraryService: PatternLibraryServiceProtocol = PatternLibraryService()) {
        self.patternLibraryService = patternLibraryService
    }

    // MARK: - Public Methods

    func loadPatterns() {
        isLoading = true
        error = nil

        patterns = patternLibraryService.loadCommonPatterns()
        isLoading = false
    }

    func selectPattern(_ pattern: Pattern) {
        selectedPattern = pattern
        patternLibraryService.copyPattern(pattern)
    }

    func clearSelection() {
        selectedPattern = nil
    }

    func clearFilters() {
        selectedCategory = nil
        searchText = ""
    }
}
