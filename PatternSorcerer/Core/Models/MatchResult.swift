//
//  MatchResult.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Result of a regex match operation
struct MatchResult: Identifiable, Hashable {
    let id: UUID
    let range: NSRange
    let matchedText: String
    let captureGroups: [CaptureGroup]
    let matchNumber: Int

    init(
        id: UUID = UUID(),
        range: NSRange,
        matchedText: String,
        captureGroups: [CaptureGroup] = [],
        matchNumber: Int
    ) {
        self.id = id
        self.range = range
        self.matchedText = matchedText
        self.captureGroups = captureGroups
        self.matchNumber = matchNumber
    }
}

/// Capture group from a regex match
struct CaptureGroup: Identifiable, Hashable {
    let id: UUID
    let index: Int
    let range: NSRange
    let text: String

    init(
        id: UUID = UUID(),
        index: Int,
        range: NSRange,
        text: String
    ) {
        self.id = id
        self.index = index
        self.range = range
        self.text = text
    }
}
