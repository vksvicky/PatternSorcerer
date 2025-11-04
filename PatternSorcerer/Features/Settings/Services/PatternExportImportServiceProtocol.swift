//
//  PatternExportImportServiceProtocol.swift
//  PatternSorcerer
//
//  Protocol for pattern export/import functionality
//
//  Created on 2025-11-04
//

import Foundation

protocol PatternExportImportServiceProtocol {
    func exportPatterns(_ patterns: [Pattern]) throws -> Data
    func importPatterns(from data: Data) throws -> [Pattern]
    func exportPatternsToFile(_ patterns: [Pattern], url: URL) throws
    func importPatternsFromFile(url: URL) throws -> [Pattern]
}
