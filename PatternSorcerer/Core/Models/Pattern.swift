//
//  Pattern.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation
import SwiftData

/// Main pattern model for storing regex patterns
@Model
final class Pattern {
    var id: UUID
    var name: String
    var pattern: String
    var patternDescription: String
    var category: PatternCategory
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
    var testCases: [TestCase]

    init(
        id: UUID = UUID(),
        name: String,
        pattern: String,
        patternDescription: String = "",
        category: PatternCategory = .general,
        tags: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        testCases: [TestCase] = []
    ) {
        self.id = id
        self.name = name
        self.pattern = pattern
        self.patternDescription = patternDescription
        self.category = category
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.testCases = testCases
    }
}

// MARK: - Pattern Category
enum PatternCategory: String, Codable, CaseIterable {
    case general = "General"
    case email = "Email"
    case url = "URL"
    case phone = "Phone"
    case date = "Date"
    case creditCard = "Credit Card"
    case ipAddress = "IP Address"
    case custom = "Custom"
}

// MARK: - Test Case
@Model
final class TestCase {
    var id: UUID
    var name: String
    var testText: String
    var expectedMatches: Int
    var shouldMatch: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        testText: String,
        expectedMatches: Int = 0,
        shouldMatch: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.testText = testText
        self.expectedMatches = expectedMatches
        self.shouldMatch = shouldMatch
        self.createdAt = createdAt
    }
}
