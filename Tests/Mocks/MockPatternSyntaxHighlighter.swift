//
//  MockPatternSyntaxHighlighter.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

import Foundation
@testable import PatternSorcerer

class MockPatternSyntaxHighlighter: PatternSyntaxHighlighterProtocol {
    var highlightCalled = false
    var highlightPattern: String?
    var highlightResult: [SyntaxToken] = []

    func highlight(pattern: String) -> [SyntaxToken] {
        highlightCalled = true
        highlightPattern = pattern
        return highlightResult
    }
}
