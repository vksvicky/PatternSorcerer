//
//  RegexFlavor.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Supported regex flavors
enum RegexFlavor: String, Codable, CaseIterable, Identifiable {
    case ecmascript = "ECMAScript"
    case pcre = "PCRE"
    case python = "Python"
    case dotnet = ".NET"
    case java = "Java"

    var id: String {
        rawValue
    }

    var description: String {
        switch self {
        case .ecmascript:
            return "JavaScript/ECMAScript regex (used in JavaScript, TypeScript)"
        case .pcre:
            return "Perl Compatible Regular Expressions (used in many languages)"
        case .python:
            return "Python re module regex"
        case .dotnet:
            return ".NET System.Text.RegularExpressions"
        case .java:
            return "Java java.util.regex"
        }
    }

    var icon: String {
        switch self {
        case .ecmascript:
            return "curlybraces"
        case .pcre:
            return "puzzlepiece"
        case .python:
            return "snake"
        case .dotnet:
            return "dot.circle"
        case .java:
            return "cup.and.saucer"
        }
    }
}

/// Flavor-specific feature information
struct FlavorFeature: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let supported: Bool
}

/// Flavor information
struct FlavorInfo: Identifiable {
    let id = UUID()
    let flavor: RegexFlavor
    let description: String
    let features: [FlavorFeature]
    let commonUseCases: [String]
    let limitations: [String]
}

/// Difference between two flavors
struct FlavorDifference: Identifiable {
    let id = UUID()
    let feature: String
    let flavor1Support: String
    let flavor2Support: String
    let description: String
}
