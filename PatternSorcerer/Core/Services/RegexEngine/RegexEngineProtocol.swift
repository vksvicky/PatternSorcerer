//
//  RegexEngineProtocol.swift
//  PatternSorcerer
//
//  Protocol for regex engine to enable mocking in tests
//
//  Created on 2025-11-04
//

import Foundation

/// Protocol for regex matching operations
protocol RegexEngineProtocol {
    /// Match a pattern against text
    func match(pattern: String, in text: String, options: NSRegularExpression.Options) throws -> [MatchResult]

    /// Replace matches in text
    func replace(
        pattern: String,
        in text: String,
        with replacement: String,
        options: NSRegularExpression.Options
    ) throws -> String

    /// Split text by pattern
    func split(pattern: String, in text: String, options: NSRegularExpression.Options) throws -> [String]

    /// Validate pattern syntax
    func validatePattern(_ pattern: String) -> (isValid: Bool, error: String?)
}
