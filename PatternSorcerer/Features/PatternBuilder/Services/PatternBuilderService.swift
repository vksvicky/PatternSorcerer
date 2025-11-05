//
//  PatternBuilderService.swift
//  PatternSorcerer
//
//  Service for building regex patterns from visual components
//
//  Created on 2025-11-05
//

import Foundation

final class PatternBuilderService: PatternBuilderServiceProtocol {
    // MARK: - Generate Pattern

    func generatePattern(from components: [PatternComponent]) throws -> String {
        var pattern = ""

        for component in components {
            switch component {
            case .literal(let text):
                pattern += escapeLiteral(text)

            case .characterClass(let type):
                pattern += type.rawValue

            case .quantifier(let type):
                pattern += type.rawValue

            case .anchor(let type):
                pattern += type.rawValue

            case .group(let type):
                switch type {
                case .capturing:
                    // Note: This is simplified - in real implementation,
                    // we'd need to track open/close groups
                    pattern += "("
                case .nonCapturing:
                    pattern += "(?:"
                case .positiveLookahead:
                    pattern += "(?="
                case .negativeLookahead:
                    pattern += "(?!"
                case .positiveLookbehind:
                    pattern += "(?<="
                case .negativeLookbehind:
                    pattern += "(?<!"
                case .custom:
                    pattern += "("
                }

            case .alternation:
                pattern += "|"

            case .custom(let text):
                pattern += text
            }
        }

        return pattern
    }

    // MARK: - Validate Pattern

    func validatePattern(_ pattern: String) -> (isValid: Bool, error: String?) {
        do {
            _ = try NSRegularExpression(pattern: pattern)
            return (true, nil)
        } catch {
            return (false, error.localizedDescription)
        }
    }

    // MARK: - Preview Pattern

    func previewPattern(_ pattern: String, with testText: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }

        let nsString = testText as NSString
        let range = NSRange(location: 0, length: nsString.length)
        let matches = regex.matches(in: testText, options: [], range: range)

        return matches.map { match in
            let matchRange = match.range
            return nsString.substring(with: matchRange)
        }
    }

    // MARK: - Private Helpers

    private func escapeLiteral(_ text: String) -> String {
        // Escape special regex characters in literal text
        let specialCharacters = CharacterSet(charactersIn: ".*+?^${}()|[]\\")
        var escaped = ""

        for char in text {
            let charString = String(char)
            if charString.rangeOfCharacter(from: specialCharacters) != nil {
                escaped += "\\"
            }
            escaped += charString
        }

        return escaped
    }
}
