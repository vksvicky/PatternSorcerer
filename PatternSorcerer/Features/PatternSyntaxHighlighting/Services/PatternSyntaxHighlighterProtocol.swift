//
//  PatternSyntaxHighlighterProtocol.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Protocol for pattern syntax highlighting
protocol PatternSyntaxHighlighterProtocol {
    /// Highlight a regex pattern and return syntax tokens
    func highlight(pattern: String) -> [SyntaxToken]
}
