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
    var matchError: Error?
    var replaceResult: String = ""
    var splitResult: [String] = []
    var validationResult: (isValid: Bool, error: String?) = (true, nil)

    // MARK: - RegexEngineProtocol

    func match(pattern: String, in text: String, options: NSRegularExpression.Options) throws -> [MatchResult] {
        if let error = matchError {
            throw error
        }
        return matchResult
    }

    func replace(pattern: String, in text: String, with replacement: String, options: NSRegularExpression.Options) throws -> String {
        return replaceResult
    }

    func split(pattern: String, in text: String, options: NSRegularExpression.Options) throws -> [String] {
        return splitResult
    }

    func validatePattern(_ pattern: String) -> (isValid: Bool, error: String?) {
        return validationResult
    }
}
