//
//  RegexEngine.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation
import SwiftUI

/// Main regex engine service
class RegexEngine: RegexEngineProtocol {
    // MARK: - Initialization

    init() {
        Logger.debug("RegexEngine initialized")
    }

    /// Match a pattern against text
    func match(pattern: String, in text: String, options: NSRegularExpression.Options = []) throws -> [MatchResult] {
        Logger.debug("Matching pattern: \(pattern)")
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        let nsString = text as NSString
        let range = NSRange(location: 0, length: nsString.length)

        let matches = regex.matches(in: text, options: [], range: range)
        Logger.info("Found \(matches.count) matches")

        return matches.enumerated().map { index, match in
            let matchRange = match.range
            let matchedText = nsString.substring(with: matchRange)

            // Extract capture groups
            let captureGroups = (1..<match.numberOfRanges).compactMap { groupIndex -> CaptureGroup? in
                let groupRange = match.range(at: groupIndex)
                guard groupRange.location != NSNotFound else { return nil }

                let groupText = nsString.substring(with: groupRange)
                return CaptureGroup(
                    index: groupIndex,
                    range: groupRange,
                    text: groupText
                )
            }

            return MatchResult(
                range: matchRange,
                matchedText: matchedText,
                captureGroups: captureGroups,
                matchNumber: index + 1
            )
        }
    }

    /// Replace matches in text
    func replace(pattern: String, in text: String, with replacement: String, options: NSRegularExpression.Options = []) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        let range = NSRange(location: 0, length: (text as NSString).length)

        return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: replacement)
    }

    /// Split text by pattern
    func split(pattern: String, in text: String, options: NSRegularExpression.Options = []) throws -> [String] {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        let nsString = text as NSString
        let range = NSRange(location: 0, length: nsString.length)

        var results: [String] = []
        var lastIndex = 0

        let matches = regex.matches(in: text, options: [], range: range)

        for match in matches {
            if match.range.location > lastIndex {
                let substring = nsString.substring(with: NSRange(location: lastIndex, length: match.range.location - lastIndex))
                results.append(substring)
            }
            lastIndex = match.range.location + match.range.length
        }

        if lastIndex < nsString.length {
            let substring = nsString.substring(with: NSRange(location: lastIndex, length: nsString.length - lastIndex))
            results.append(substring)
        }

        return results.filter { !$0.isEmpty }
    }

    /// Validate pattern syntax
    func validatePattern(_ pattern: String) -> (isValid: Bool, error: String?) {
        Logger.debug("Validating pattern: \(pattern)")
        do {
            _ = try NSRegularExpression(pattern: pattern, options: [])
            Logger.debug("Pattern is valid")
            return (true, nil)
        } catch {
            Logger.warning("Pattern validation failed: \(error.localizedDescription)")
            return (false, error.localizedDescription)
        }
    }
}
