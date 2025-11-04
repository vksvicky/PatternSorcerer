//
//  MockPatternExportImportService.swift
//  PatternSorcererTests
//
//  Mock implementation of PatternExportImportServiceProtocol for testing
//
//  Created on 2025-11-04
//

import Foundation
@testable import PatternSorcerer

class MockPatternExportImportService: PatternExportImportServiceProtocol {
    var exportPatternsCalled = false
    var exportedPatterns: [Pattern] = []
    var exportError: Error?

    var importPatternsCalled = false
    var importData: Data?
    var importedPatterns: [Pattern] = []
    var importError: Error?

    var exportToFileCalled = false
    var exportFileURL: URL?
    var exportFileError: Error?

    var importFromFileCalled = false
    var importFileURL: URL?
    var importFileError: Error?

    func exportPatterns(_ patterns: [Pattern]) throws -> Data {
        exportPatternsCalled = true
        exportedPatterns = patterns
        if let error = exportError {
            throw error
        }
        return Data()
    }

    func importPatterns(from data: Data) throws -> [Pattern] {
        importPatternsCalled = true
        importData = data
        if let error = importError {
            throw error
        }
        return importedPatterns
    }

    func exportPatternsToFile(_ patterns: [Pattern], url: URL) throws {
        exportToFileCalled = true
        exportFileURL = url
        if let error = exportFileError {
            throw error
        }
    }

    func importPatternsFromFile(url: URL) throws -> [Pattern] {
        importFromFileCalled = true
        importFileURL = url
        if let error = importFileError {
            throw error
        }
        return importedPatterns
    }
}
