//
//  PatternLibraryServiceProtocol.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Protocol for pattern library service operations
protocol PatternLibraryServiceProtocol {
    /// Load common patterns from the library
    func loadCommonPatterns() -> [Pattern]

    /// Copy pattern to clipboard
    func copyPattern(_ pattern: Pattern)

    /// Search patterns by query
    func searchPatterns(_ query: String, in patterns: [Pattern]) -> [Pattern]

    /// Filter patterns by category
    func filterPatterns(_ patterns: [Pattern], by category: PatternCategory?) -> [Pattern]
}
