//
//  RegexFlavorServiceProtocol.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

/// Protocol for regex flavor service operations
protocol RegexFlavorServiceProtocol {
    /// Set the active regex flavor
    func setFlavor(_ flavor: RegexFlavor)

    /// Validate pattern for a specific flavor
    func validatePattern(_ pattern: String, for flavor: RegexFlavor) -> (isValid: Bool, error: String?)

    /// Get differences between two flavors
    func getFlavorDifferences(between flavor1: RegexFlavor, and flavor2: RegexFlavor) -> [FlavorDifference]

    /// Get information about a flavor
    func getFlavorInfo(for flavor: RegexFlavor) -> FlavorInfo?

    /// Get all available flavors
    func getAvailableFlavors() -> [RegexFlavor]

    /// Get features supported by a flavor
    func getFlavorFeatures(for flavor: RegexFlavor) -> [FlavorFeature]
}
