//
//  RegexDebugStep.swift
//  PatternSorcerer
//
//  Model representing a single step in regex debugging
//
//  Created on 2025-12-XX
//

import Foundation

/// Represents a single step in the regex debugging process
struct RegexDebugStep: Identifiable, Equatable {
    let id: UUID
    let stepNumber: Int
    let patternPosition: Int
    let textPosition: Int
    let matchedText: String
    let state: DebugState
    let description: String

    init(
        id: UUID = UUID(),
        stepNumber: Int,
        patternPosition: Int,
        textPosition: Int,
        matchedText: String,
        state: DebugState,
        description: String
    ) {
        self.id = id
        self.stepNumber = stepNumber
        self.patternPosition = patternPosition
        self.textPosition = textPosition
        self.matchedText = matchedText
        self.state = state
        self.description = description
    }
}

/// Debug state for a regex step
enum DebugState: String, Equatable {
    case matching = "Matching"
    case matchFound = "Match Found"
    case noMatch = "No Match"
    case backtracking = "Backtracking"
    case error = "Error"
}
