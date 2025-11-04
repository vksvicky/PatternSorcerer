//
//  TestCaseTemplate.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Template for creating test cases
struct TestCaseTemplate: Identifiable {
    let id: UUID
    let name: String
    let testText: String
    let expectedMatches: Int
    let shouldMatch: Bool
    let description: String?

    init(
        id: UUID = UUID(),
        name: String,
        testText: String,
        expectedMatches: Int = 1,
        shouldMatch: Bool = true,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.testText = testText
        self.expectedMatches = expectedMatches
        self.shouldMatch = shouldMatch
        self.description = description
    }

    func toTestCase() -> TestCase {
        TestCase(
            name: name,
            testText: testText,
            expectedMatches: expectedMatches,
            shouldMatch: shouldMatch
        )
    }
}
