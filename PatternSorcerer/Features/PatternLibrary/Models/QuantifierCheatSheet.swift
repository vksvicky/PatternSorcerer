//
//  QuantifierCheatSheet.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Quantifier cheat sheet item
struct QuantifierCheatSheet: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    let name: String
    let description: String
    let example: String

    static let common: [QuantifierCheatSheet] = [
        QuantifierCheatSheet(
            symbol: "*",
            name: "Zero or More",
            description: "Matches zero or more occurrences of the preceding element",
            example: "a* matches '', 'a', 'aa', 'aaa', etc."
        ),
        QuantifierCheatSheet(
            symbol: "+",
            name: "One or More",
            description: "Matches one or more occurrences of the preceding element",
            example: "a+ matches 'a', 'aa', 'aaa', etc. (not '')"
        ),
        QuantifierCheatSheet(
            symbol: "?",
            name: "Zero or One",
            description: "Matches zero or one occurrence of the preceding element",
            example: "a? matches '' or 'a'"
        ),
        QuantifierCheatSheet(
            symbol: "{n}",
            name: "Exactly N",
            description: "Matches exactly n occurrences",
            example: "a{3} matches 'aaa'"
        ),
        QuantifierCheatSheet(
            symbol: "{n,}",
            name: "N or More",
            description: "Matches n or more occurrences",
            example: "a{2,} matches 'aa', 'aaa', 'aaaa', etc."
        ),
        QuantifierCheatSheet(
            symbol: "{n,m}",
            name: "Between N and M",
            description: "Matches between n and m occurrences (inclusive)",
            example: "a{2,4} matches 'aa', 'aaa', or 'aaaa'"
        ),
        QuantifierCheatSheet(
            symbol: "*?",
            name: "Lazy Zero or More",
            description: "Non-greedy version of *",
            example: "a*? matches as few as possible"
        ),
        QuantifierCheatSheet(
            symbol: "+?",
            name: "Lazy One or More",
            description: "Non-greedy version of +",
            example: "a+? matches as few as possible (at least one)"
        ),
        QuantifierCheatSheet(
            symbol: "??",
            name: "Lazy Zero or One",
            description: "Non-greedy version of ?",
            example: "a?? prefers zero matches"
        )
    ]
}
