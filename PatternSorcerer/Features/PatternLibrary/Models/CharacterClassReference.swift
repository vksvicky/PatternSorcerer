//
//  CharacterClassReference.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Character class reference item
struct CharacterClassReference: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    let name: String
    let description: String
    let example: String

    static let common: [CharacterClassReference] = [
        CharacterClassReference(
            symbol: "\\d",
            name: "Digit",
            description: "Matches any digit (0-9)",
            example: "\\d+ matches '123'"
        ),
        CharacterClassReference(
            symbol: "\\D",
            name: "Non-digit",
            description: "Matches any character that is not a digit",
            example: "\\D+ matches 'abc'"
        ),
        CharacterClassReference(
            symbol: "\\w",
            name: "Word Character",
            description: "Matches any word character (a-z, A-Z, 0-9, _)",
            example: "\\w+ matches 'hello_123'"
        ),
        CharacterClassReference(
            symbol: "\\W",
            name: "Non-word Character",
            description: "Matches any character that is not a word character",
            example: "\\W matches '!' or '@'"
        ),
        CharacterClassReference(
            symbol: "\\s",
            name: "Whitespace",
            description: "Matches any whitespace character (space, tab, newline)",
            example: "\\s+ matches multiple spaces"
        ),
        CharacterClassReference(
            symbol: "\\S",
            name: "Non-whitespace",
            description: "Matches any character that is not whitespace",
            example: "\\S+ matches 'hello'"
        ),
        CharacterClassReference(
            symbol: ".",
            name: "Any Character",
            description: "Matches any character except newline",
            example: ".+ matches any sequence"
        ),
        CharacterClassReference(
            symbol: "[abc]",
            name: "Character Set",
            description: "Matches any one of the characters in the set",
            example: "[abc] matches 'a', 'b', or 'c'"
        ),
        CharacterClassReference(
            symbol: "[^abc]",
            name: "Negated Set",
            description: "Matches any character not in the set",
            example: "[^abc] matches 'd', 'e', etc."
        ),
        CharacterClassReference(
            symbol: "[a-z]",
            name: "Range",
            description: "Matches any character in the range",
            example: "[a-z] matches lowercase letters"
        ),
        CharacterClassReference(
            symbol: "[0-9]",
            name: "Digit Range",
            description: "Matches any digit from 0 to 9",
            example: "[0-9]+ matches '123'"
        ),
        CharacterClassReference(
            symbol: "[A-Za-z]",
            name: "Letter Range",
            description: "Matches any letter (upper or lowercase)",
            example: "[A-Za-z]+ matches 'Hello'"
        )
    ]
}
