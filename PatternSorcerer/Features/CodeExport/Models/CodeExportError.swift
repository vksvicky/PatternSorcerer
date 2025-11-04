//
//  CodeExportError.swift
//  PatternSorcerer
//
//  Error types for code export operations
//
//  Created on 2025-11-04
//

import Foundation

/// Custom error types for code export operations
enum CodeExportError: LocalizedError {
    case invalidPattern(String)
    case unsupportedLanguage(CodeLanguage)
    case exportFailed(String)
    case fileSaveFailed(URL, Error)

    var errorDescription: String? {
        switch self {
        case .invalidPattern(let pattern):
            return "Invalid pattern: \(pattern)"
        case .unsupportedLanguage(let language):
            return "Unsupported language: \(language.rawValue)"
        case .exportFailed(let message):
            return "Export failed: \(message)"
        case .fileSaveFailed(let url, let error):
            return "Failed to save file to \(url.path): \(error.localizedDescription)"
        }
    }
}
