//
//  RegexFlavorService.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Service for managing regex flavor operations
final class RegexFlavorService: RegexFlavorServiceProtocol {
    private var currentFlavor: RegexFlavor = .ecmascript

    // MARK: - RegexFlavorServiceProtocol

    func setFlavor(_ flavor: RegexFlavor) {
        currentFlavor = flavor
    }

    func validatePattern(_ pattern: String, for flavor: RegexFlavor) -> (isValid: Bool, error: String?) {
        // For now, we use NSRegularExpression which is ECMAScript-based
        // In a full implementation, we would use flavor-specific validators
        let regexEngine = RegexEngine()
        return regexEngine.validatePattern(pattern)
    }

    func getFlavorDifferences(between flavor1: RegexFlavor, and flavor2: RegexFlavor) -> [FlavorDifference] {
        var differences: [FlavorDifference] = []

        // Character class differences
        if flavor1 != flavor2 {
            differences.append(FlavorDifference(
                feature: "Word Boundary",
                flavor1Support: flavor1 == .ecmascript ? "\\b supported" : "Varies",
                flavor2Support: flavor2 == .ecmascript ? "\\b supported" : "Varies",
                description: "Word boundary support differs between flavors"
            ))
        }

        // Lookahead/lookbehind differences
        differences.append(FlavorDifference(
            feature: "Lookahead/Lookbehind",
            flavor1Support: flavor1 == .pcre || flavor1 == .ecmascript ? "Full support" : "Limited",
            flavor2Support: flavor2 == .pcre || flavor2 == .ecmascript ? "Full support" : "Limited",
            description: "Lookahead and lookbehind assertion support varies"
        ))

        return differences
    }

    func getFlavorInfo(for flavor: RegexFlavor) -> FlavorInfo? {
        let features = getFlavorFeatures(for: flavor)
        let (commonUseCases, limitations) = getFlavorUseCasesAndLimitations(for: flavor)

        return FlavorInfo(
            flavor: flavor,
            description: flavor.description,
            features: features,
            commonUseCases: commonUseCases,
            limitations: limitations
        )
    }

    private func getFlavorUseCasesAndLimitations(for flavor: RegexFlavor) -> (useCases: [String], limitations: [String]) {
        switch flavor {
        case .ecmascript:
            return (
                ["JavaScript/TypeScript applications", "Web development", "Browser-based validation"],
                ["No lookbehind in older versions", "Limited character class support"]
            )
        case .pcre:
            return (
                ["Perl applications", "PHP applications", "Many text editors"],
                ["Backtracking can be expensive", "Some advanced features not in all implementations"]
            )
        case .python:
            return (
                ["Python applications", "Data processing scripts", "Text parsing"],
                ["Limited lookbehind support", "Unicode handling can be complex"]
            )
        case .dotnet:
            return (
                [".NET applications", "C# and F# programs", "ASP.NET web applications"],
                ["Platform-specific", "Performance considerations for large text"]
            )
        case .java:
            return (
                ["Java applications", "Android development", "Enterprise applications"],
                ["Backtracking limits", "Memory usage for complex patterns"]
            )
        }
    }

    func getAvailableFlavors() -> [RegexFlavor] {
        RegexFlavor.allCases
    }

    func getFlavorFeatures(for flavor: RegexFlavor) -> [FlavorFeature] {
        switch flavor {
        case .ecmascript:
            return [
                FlavorFeature(name: "Lookahead", description: "Positive and negative lookahead", supported: true),
                FlavorFeature(name: "Lookbehind", description: "Positive and negative lookbehind (ES2018+)", supported: true),
                FlavorFeature(name: "Unicode", description: "Unicode property escapes", supported: true),
                FlavorFeature(name: "Named Groups", description: "Named capture groups", supported: true)
            ]
        case .pcre:
            return [
                FlavorFeature(name: "Lookahead", description: "Positive and negative lookahead", supported: true),
                FlavorFeature(name: "Lookbehind", description: "Positive and negative lookbehind", supported: true),
                FlavorFeature(name: "Recursion", description: "Pattern recursion", supported: true),
                FlavorFeature(name: "Atomic Groups", description: "Atomic grouping", supported: true),
                FlavorFeature(name: "Conditional Patterns", description: "Conditional expressions", supported: true)
            ]
        case .python:
            return [
                FlavorFeature(name: "Lookahead", description: "Positive and negative lookahead", supported: true),
                FlavorFeature(name: "Lookbehind", description: "Fixed-width lookbehind", supported: true),
                FlavorFeature(name: "Named Groups", description: "Named capture groups", supported: true),
                FlavorFeature(name: "Verbose Mode", description: "Whitespace and comments", supported: true)
            ]
        case .dotnet:
            return [
                FlavorFeature(name: "Lookahead", description: "Positive and negative lookahead", supported: true),
                FlavorFeature(name: "Lookbehind", description: "Variable-width lookbehind", supported: true),
                FlavorFeature(name: "Balancing Groups", description: "Balancing group definitions", supported: true),
                FlavorFeature(name: "Right-to-Left", description: "Right-to-left matching", supported: true)
            ]
        case .java:
            return [
                FlavorFeature(name: "Lookahead", description: "Positive and negative lookahead", supported: true),
                FlavorFeature(name: "Lookbehind", description: "Fixed and variable-width lookbehind", supported: true),
                FlavorFeature(name: "Named Groups", description: "Named capture groups (Java 7+)", supported: true),
                FlavorFeature(name: "Unicode", description: "Unicode support", supported: true)
            ]
        }
    }
}
