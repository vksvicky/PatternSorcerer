//
//  PatternExportImportService.swift
//  PatternSorcerer
//
//  Service for exporting and importing patterns
//
//  Created on 2025-11-04
//

import Foundation
import SwiftData

class PatternExportImportService: PatternExportImportServiceProtocol {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init() {
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    func exportPatterns(_ patterns: [Pattern]) throws -> Data {
        let exportData = patterns.map { pattern in
            PatternExportData(
                id: pattern.id,
                name: pattern.name,
                pattern: pattern.pattern,
                patternDescription: pattern.patternDescription,
                category: pattern.category,
                tags: pattern.tags,
                createdAt: pattern.createdAt,
                updatedAt: pattern.updatedAt,
                testCases: pattern.testCases.map { testCase in
                    TestCaseExportData(
                        id: testCase.id,
                        name: testCase.name,
                        testText: testCase.testText,
                        expectedMatches: testCase.expectedMatches,
                        shouldMatch: testCase.shouldMatch,
                        createdAt: testCase.createdAt
                    )
                }
            )
        }

        return try encoder.encode(exportData)
    }

    func importPatterns(from data: Data) throws -> [Pattern] {
        let exportData = try decoder.decode([PatternExportData].self, from: data)
        return exportData.map { data in
            Pattern(
                id: data.id,
                name: data.name,
                pattern: data.pattern,
                patternDescription: data.patternDescription,
                category: data.category,
                tags: data.tags,
                createdAt: data.createdAt,
                updatedAt: data.updatedAt,
                testCases: data.testCases.map { testCaseData in
                    TestCase(
                        id: testCaseData.id,
                        name: testCaseData.name,
                        testText: testCaseData.testText,
                        expectedMatches: testCaseData.expectedMatches,
                        shouldMatch: testCaseData.shouldMatch,
                        createdAt: testCaseData.createdAt
                    )
                }
            )
        }
    }

    func exportPatternsToFile(_ patterns: [Pattern], url: URL) throws {
        let data = try exportPatterns(patterns)
        try data.write(to: url)
    }

    func importPatternsFromFile(url: URL) throws -> [Pattern] {
        let data = try Data(contentsOf: url)
        return try importPatterns(from: data)
    }
}

// MARK: - Export Data Models

struct PatternExportData: Codable {
    let id: UUID
    let name: String
    let pattern: String
    let patternDescription: String
    let category: PatternCategory
    let tags: [String]
    let createdAt: Date
    let updatedAt: Date
    let testCases: [TestCaseExportData]
}

struct TestCaseExportData: Codable {
    let id: UUID
    let name: String
    let testText: String
    let expectedMatches: Int
    let shouldMatch: Bool
    let createdAt: Date
}
