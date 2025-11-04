//
//  RegexFlavorViewModel.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation
import SwiftUI

@MainActor
final class RegexFlavorViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var selectedFlavor: RegexFlavor = .ecmascript
    @Published var availableFlavors: [RegexFlavor] = []
    @Published var flavorInfo: FlavorInfo?
    @Published var flavorFeatures: [FlavorFeature] = []
    @Published var flavorDifferences: [FlavorDifference] = []

    // MARK: - Private Properties

    private let regexFlavorService: RegexFlavorServiceProtocol

    // MARK: - Initialization

    init(regexFlavorService: RegexFlavorServiceProtocol = RegexFlavorService()) {
        self.regexFlavorService = regexFlavorService
        loadAvailableFlavors()
    }

    // MARK: - Public Methods

    func loadAvailableFlavors() {
        availableFlavors = regexFlavorService.getAvailableFlavors()
    }

    func selectFlavor(_ flavor: RegexFlavor) {
        selectedFlavor = flavor
        regexFlavorService.setFlavor(flavor)
        updateFlavorInfo()
        updateFlavorFeatures()
    }

    func validatePattern(_ pattern: String) -> (isValid: Bool, error: String?) {
        regexFlavorService.validatePattern(pattern, for: selectedFlavor)
    }

    func getFlavorDifferences(between flavor1: RegexFlavor, and flavor2: RegexFlavor) -> [FlavorDifference] {
        flavorDifferences = regexFlavorService.getFlavorDifferences(between: flavor1, and: flavor2)
        return flavorDifferences
    }

    func getFlavorInfo() -> FlavorInfo? {
        flavorInfo = regexFlavorService.getFlavorInfo(for: selectedFlavor)
        return flavorInfo
    }

    func getFlavorFeatures() -> [FlavorFeature] {
        flavorFeatures = regexFlavorService.getFlavorFeatures(for: selectedFlavor)
        return flavorFeatures
    }

    // MARK: - Private Methods

    private func updateFlavorInfo() {
        flavorInfo = regexFlavorService.getFlavorInfo(for: selectedFlavor)
    }

    private func updateFlavorFeatures() {
        flavorFeatures = regexFlavorService.getFlavorFeatures(for: selectedFlavor)
    }
}
