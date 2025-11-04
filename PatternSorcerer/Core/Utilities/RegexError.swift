//
//  RegexError.swift
//  PatternSorcerer
//
//  Custom error types for regex operations
//
//  Created on 2025-11-04
//

import Foundation

/// Custom error types for regex operations
enum RegexError: LocalizedError {
    case invalidPattern(String)
    case emptyPattern
    case emptyTestText
    case compileError(String)
    case matchError(String)
    case replaceError(String)

    var errorDescription: String? {
        switch self {
        case .invalidPattern(let pattern):
            return "Invalid pattern: \(pattern)"
        case .emptyPattern:
            return "Pattern cannot be empty"
        case .emptyTestText:
            return "Test text cannot be empty"
        case .compileError(let message):
            return "Failed to compile pattern: \(message)"
        case .matchError(let message):
            return "Failed to match pattern: \(message)"
        case .replaceError(let message):
            return "Failed to replace matches: \(message)"
        }
    }

    var failureReason: String? {
        switch self {
        case .invalidPattern:
            return "The regex pattern contains syntax errors."
        case .emptyPattern:
            return "Please enter a regex pattern to test."
        case .emptyTestText:
            return "Please enter text to test against the pattern."
        case .compileError(let message):
            return "The pattern could not be compiled: \(message)"
        case .matchError(let message):
            return "An error occurred while matching: \(message)"
        case .replaceError(let message):
            return "An error occurred while replacing: \(message)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidPattern:
            return "Check the pattern syntax and try again. " +
                   "Common issues: unclosed brackets, invalid escape sequences, or malformed quantifiers."
        case .emptyPattern:
            return "Enter a regex pattern in the pattern field."
        case .emptyTestText:
            return "Enter some text in the test text field."
        case .compileError:
            return "Review the pattern syntax and ensure all special characters are properly escaped."
        case .matchError:
            return "Try simplifying the pattern or checking the regex options."
        case .replaceError:
            return "Verify the replacement string format and pattern syntax."
        }
    }

    /// Parse NSRegularExpression error and convert to RegexError
    static func fromNSError(_ error: NSError, pattern: String) -> RegexError {
        let errorMessage = error.localizedDescription

        // NSRegularExpression error codes (from Foundation)
        // Note: These are internal error codes, so we use the error domain and code
        let regexErrorDomain = "NSCocoaErrorDomain"

        if error.domain == regexErrorDomain {
            // Try to extract meaningful error information
            if errorMessage.contains("Invalid capture group") || errorMessage.contains("capture group") {
                return .invalidPattern("Invalid capture group name: \(errorMessage)")
            }
            if errorMessage.contains("Invalid pattern") || errorMessage.contains("pattern") {
                return .invalidPattern("Invalid pattern syntax: \(errorMessage)")
            }
        }

        return .compileError(errorMessage)
    }
}

/// Error formatter for user-friendly error messages
struct ErrorFormatter {
    /// Format error for display to user
    static func format(_ error: Error) -> String {
        if let regexError = error as? RegexError {
            return regexError.errorDescription ?? "Unknown error"
        }

        if let nsError = error as NSError? {
            // Try to extract useful information from NSError
            if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
                return underlyingError.localizedDescription
            }
            return nsError.localizedDescription
        }

        return error.localizedDescription
    }

    /// Get detailed error message with suggestions
    static func detailedMessage(for error: Error) -> String {
        if let regexError = error as? RegexError {
            var message = regexError.errorDescription ?? "Unknown error"
            if let reason = regexError.failureReason {
                message += "\n\n\(reason)"
            }
            if let suggestion = regexError.recoverySuggestion {
                message += "\n\n\(suggestion)"
            }
            return message
        }

        return format(error)
    }
}
