//
//  MockRegexEngine.swift
//  PatternSorcererTests
//
//  Mock implementation of RegexEngineProtocol for testing
//
//  Created on 2025-11-04
//

import Foundation
@testable import PatternSorcerer

/// Mock regex engine for testing
class MockRegexEngine: RegexEngineProtocol {
    // MARK: - Configuration

    var matchResult: [MatchResult] = []
    var matchResults: [String: [MatchResult]] = [:] // Per-text results
    var matchError: Error?
    var shouldThrowError = false
    var replaceResult: String = ""
    var replaceError: Error?
    var splitResult: [String] = []
    var splitError: Error?
    var validationResult: (isValid: Bool, error: String?) = (true, nil)

    // MARK: - RegexEngineProtocol

    func match(pattern: String, in text: String, options: NSRegularExpression.Options) throws -> [MatchResult] {
        if shouldThrowError || matchError != nil {
            throw matchError ?? NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid pattern"])
        }
        // Check per-text results first, then fall back to general matchResult
        return matchResults[text] ?? matchResult
    }

    func replace(pattern: String, in text: String, with replacement: String, options: NSRegularExpression.Options) throws -> String {
        if let error = replaceError {
            throw error
        }
        return replaceResult
    }

    func split(pattern: String, in text: String, options: NSRegularExpression.Options) throws -> [String] {
        if let error = splitError {
            throw error
        }
        return splitResult
    }

    func validatePattern(_ pattern: String) -> (isValid: Bool, error: String?) {
        return validationResult
    }
}
