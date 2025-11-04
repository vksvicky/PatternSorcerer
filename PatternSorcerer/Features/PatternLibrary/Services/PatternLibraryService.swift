//
//  PatternLibraryService.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import Foundation

/// Service for managing pattern library operations
final class PatternLibraryService: PatternLibraryServiceProtocol {
    // MARK: - PatternLibraryServiceProtocol

    func loadCommonPatterns() -> [Pattern] {
        emailPatterns() + urlPatterns() + phonePatterns() + datePatterns() +
        creditCardPatterns() + ipAddressPatterns() + generalPatterns()
    }

    // MARK: - Pattern Categories

    private func emailPatterns() -> [Pattern] {
        [
            Pattern(
                name: "Email Address",
                pattern: "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b",
                patternDescription: "Validates email addresses",
                category: .email,
                tags: ["email", "validation", "address"]
            )
        ]
    }

    private func urlPatterns() -> [Pattern] {
        [
            Pattern(
                name: "URL (HTTP/HTTPS)",
                pattern: "https?://[^\\s]+",
                patternDescription: "Matches HTTP and HTTPS URLs",
                category: .url,
                tags: ["url", "http", "https", "link"]
            )
        ]
    }

    private func phonePatterns() -> [Pattern] {
        [
            Pattern(
                name: "US Phone Number",
                pattern: "\\d{3}-\\d{3}-\\d{4}",
                patternDescription: "Matches US phone numbers in format XXX-XXX-XXXX",
                category: .phone,
                tags: ["phone", "us", "telephone"]
            ),
            Pattern(
                name: "International Phone",
                pattern: "\\+?[1-9]\\d{1,14}",
                patternDescription: "Matches international phone numbers",
                category: .phone,
                tags: ["phone", "international"]
            )
        ]
    }

    private func datePatterns() -> [Pattern] {
        [
            Pattern(
                name: "Date (MM/DD/YYYY)",
                pattern: "\\d{1,2}/\\d{1,2}/\\d{4}",
                patternDescription: "Matches dates in MM/DD/YYYY format",
                category: .date,
                tags: ["date", "calendar"]
            ),
            Pattern(
                name: "Date (YYYY-MM-DD)",
                pattern: "\\d{4}-\\d{2}-\\d{2}",
                patternDescription: "Matches dates in ISO format (YYYY-MM-DD)",
                category: .date,
                tags: ["date", "iso", "calendar"]
            )
        ]
    }

    private func creditCardPatterns() -> [Pattern] {
        [
            Pattern(
                name: "Credit Card Number",
                pattern: "\\d{4}[\\s-]?\\d{4}[\\s-]?\\d{4}[\\s-]?\\d{4}",
                patternDescription: "Matches credit card numbers (16 digits)",
                category: .creditCard,
                tags: ["credit", "card", "payment"]
            )
        ]
    }

    private func ipAddressPatterns() -> [Pattern] {
        [
            Pattern(
                name: "IPv4 Address",
                pattern: "\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b",
                patternDescription: "Matches IPv4 addresses",
                category: .ipAddress,
                tags: ["ip", "network", "address"]
            )
        ]
    }

    private func generalPatterns() -> [Pattern] {
        [
            Pattern(
                name: "Digits Only",
                pattern: "\\d+",
                patternDescription: "Matches one or more digits",
                category: .general,
                tags: ["digits", "numbers"]
            ),
            Pattern(
                name: "Letters Only",
                pattern: "[A-Za-z]+",
                patternDescription: "Matches one or more letters",
                category: .general,
                tags: ["letters", "alphabetic"]
            ),
            Pattern(
                name: "Alphanumeric",
                pattern: "[A-Za-z0-9]+",
                patternDescription: "Matches alphanumeric characters",
                category: .general,
                tags: ["alphanumeric", "alnum"]
            ),
            Pattern(
                name: "Whitespace",
                pattern: "\\s+",
                patternDescription: "Matches one or more whitespace characters",
                category: .general,
                tags: ["whitespace", "space"]
            )
        ]
    }

    func copyPattern(_ pattern: Pattern) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(pattern.pattern, forType: .string)
    }

    func searchPatterns(_ query: String, in patterns: [Pattern]) -> [Pattern] {
        guard !query.isEmpty else {
            return patterns
        }

        let lowercasedQuery = query.lowercased()
        return patterns.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.pattern.contains(query) ||
            $0.patternDescription.lowercased().contains(lowercasedQuery) ||
            $0.tags.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }

    func filterPatterns(_ patterns: [Pattern], by category: PatternCategory?) -> [Pattern] {
        guard let category = category else {
            return patterns
        }
        return patterns.filter { $0.category == category }
    }
}
