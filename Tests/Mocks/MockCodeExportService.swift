//
//  MockCodeExportService.swift
//  PatternSorcererTests
//
//  Mock implementation of CodeExportServiceProtocol for testing
//
//  Created on 2025-11-04
//

import Foundation
@testable import PatternSorcerer

/// Mock code export service for testing
class MockCodeExportService: CodeExportServiceProtocol {
    // MARK: - Configuration

    var exportResult: String = ""
    var exportError: CodeExportError?
    var copyToClipboardCalled = false
    var saveToFileCalled = false
    var savedFileURL: URL?
    var savedFileContent: String?

    // MARK: - CodeExportServiceProtocol

    func exportCode(
        pattern: String,
        testText: String?,
        language: CodeLanguage,
        options: CodeExportOptions
    ) throws -> String {
        if let error = exportError {
            throw error
        }
        return exportResult
    }

    func copyToClipboard(_ code: String) {
        copyToClipboardCalled = true
    }

    func saveToFile(_ code: String, url: URL) throws {
        saveToFileCalled = true
        savedFileURL = url
        savedFileContent = code
    }
}
