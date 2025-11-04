//
//  MockRegexFlavorService.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

import Foundation
@testable import PatternSorcerer

class MockRegexFlavorService: RegexFlavorServiceProtocol {
    var setFlavorCalled = false
    var setFlavorValue: RegexFlavor?

    var validatePatternCalled = false
    var validatePatternValue: String?
    var validateFlavor: RegexFlavor?
    var isPatternValid = true
    var validationError: String?

    var getFlavorDifferencesCalled = false
    var flavorDifferences: [FlavorDifference] = []

    var getFlavorInfoCalled = false
    var getFlavorInfoValue: RegexFlavor?
    var flavorInfo: FlavorInfo?

    var getAvailableFlavorsCalled = false
    var availableFlavors: [RegexFlavor] = []

    var getFlavorFeaturesCalled = false
    var flavorFeatures: [FlavorFeature] = []

    func setFlavor(_ flavor: RegexFlavor) {
        setFlavorCalled = true
        setFlavorValue = flavor
    }

    func validatePattern(_ pattern: String, for flavor: RegexFlavor) -> (isValid: Bool, error: String?) {
        validatePatternCalled = true
        validatePatternValue = pattern
        validateFlavor = flavor
        return (isPatternValid, validationError)
    }

    func getFlavorDifferences(between flavor1: RegexFlavor, and flavor2: RegexFlavor) -> [FlavorDifference] {
        getFlavorDifferencesCalled = true
        return flavorDifferences
    }

    func getFlavorInfo(for flavor: RegexFlavor) -> FlavorInfo? {
        getFlavorInfoCalled = true
        getFlavorInfoValue = flavor
        return flavorInfo
    }

    func getAvailableFlavors() -> [RegexFlavor] {
        getAvailableFlavorsCalled = true
        return availableFlavors.isEmpty ? RegexFlavor.allCases : availableFlavors
    }

    func getFlavorFeatures(for flavor: RegexFlavor) -> [FlavorFeature] {
        getFlavorFeaturesCalled = true
        return flavorFeatures
    }
}
