//
//  PatternBuilderServiceProtocol.swift
//  PatternSorcerer
//
//  Protocol for pattern builder service
//
//  Created on 2025-11-05
//

import Foundation

/// Protocol for building regex patterns from visual components
protocol PatternBuilderServiceProtocol {
    /// Generate a regex pattern string from components
    func generatePattern(from components: [PatternComponent]) throws -> String

    /// Validate a pattern string
    func validatePattern(_ pattern: String) -> (isValid: Bool, error: String?)

    /// Get preview of pattern with test text
    func previewPattern(_ pattern: String, with testText: String) -> [String]
}
