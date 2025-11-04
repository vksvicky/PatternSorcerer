//
//  CodeExportOptions.swift
//  PatternSorcerer
//
//  Options for code export
//
//  Created on 2025-11-04
//

import Foundation

/// Options for code export customization
struct CodeExportOptions {
    var caseInsensitive: Bool = false
    var multiline: Bool = false
    var dotMatchesNewline: Bool = false
    var allowComments: Bool = false
    var ignoreMetacharacters: Bool = false

    /// Convert to NSRegularExpression.Options for Swift
    func toNSRegularExpressionOptions() -> NSRegularExpression.Options {
        var options: NSRegularExpression.Options = []

        if caseInsensitive {
            options.insert(.caseInsensitive)
        }
        if multiline {
            options.insert(.anchorsMatchLines)
        }
        if dotMatchesNewline {
            options.insert(.dotMatchesLineSeparators)
        }
        if allowComments {
            options.insert(.allowCommentsAndWhitespace)
        }
        if ignoreMetacharacters {
            options.insert(.ignoreMetacharacters)
        }

        return options
    }
}
