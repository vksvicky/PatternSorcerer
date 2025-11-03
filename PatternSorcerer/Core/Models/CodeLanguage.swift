//
//  CodeLanguage.swift
//  PatternSorcerer
//
//  Created on $(date)
//

import Foundation

/// Supported programming languages for code export
enum CodeLanguage: String, CaseIterable, Identifiable {
    case swift = "Swift"
    case python = "Python"
    case javascript = "JavaScript"
    case java = "Java"
    case go = "Go"
    case rust = "Rust"
    case csharp = "C#"
    case ruby = "Ruby"
    case php = "PHP"
    
    var id: String { rawValue }
    
    var fileExtension: String {
        switch self {
        case .swift: return "swift"
        case .python: return "py"
        case .javascript: return "js"
        case .java: return "java"
        case .go: return "go"
        case .rust: return "rs"
        case .csharp: return "cs"
        case .ruby: return "rb"
        case .php: return "php"
        }
    }
    
    var commentPrefix: String {
        switch self {
        case .swift, .javascript, .java, .csharp, .go, .rust: return "//"
        case .python, .ruby: return "#"
        case .php: return "//"
        }
    }
}


