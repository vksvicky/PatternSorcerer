//
//  CodeExportServiceProtocol.swift
//  PatternSorcerer
//
//  Protocol for code export service to enable mocking in tests
//
//  Created on 2025-11-04
//

import Foundation

/// Protocol for exporting regex patterns to code
protocol CodeExportServiceProtocol {
    /// Export a regex pattern to code in the specified language
    func exportCode(
        pattern: String,
        testText: String?,
        language: CodeLanguage,
        options: CodeExportOptions
    ) throws -> String

    /// Copy code to clipboard
    func copyToClipboard(_ code: String)

    /// Save code to file
    func saveToFile(_ code: String, url: URL) throws
}
