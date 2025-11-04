//
//  ReplaceOptions.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Options for replace operations
struct ReplaceOptions {
    var caseInsensitive: Bool = false
    var multiline: Bool = false
    var dotMatchesNewline: Bool = false

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
        return options
    }
}
