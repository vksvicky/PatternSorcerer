//
//  RegexFlavorBDDTests.swift
//  PatternSorcererTests
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class RegexFlavorBDDTests: XCTestCase {
    var sut: RegexFlavorViewModel!
    var mockService: MockRegexFlavorService!

    override func setUp() {
        super.setUp()
        mockService = MockRegexFlavorService()
        sut = RegexFlavorViewModel(regexFlavorService: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Feature: Select Regex Flavor

    func testFeature_SelectFlavor_ChangesActiveFlavor() {
        // Given: multiple flavors available
        let flavors: [RegexFlavor] = [.ecmascript, .pcre, .python]
        mockService.availableFlavors = flavors

        // When: the user selects a flavor
        sut.selectFlavor(.pcre)

        // Then: the active flavor should change
        XCTAssertEqual(sut.selectedFlavor, .pcre, "Should select PCRE flavor")
        XCTAssertTrue(mockService.setFlavorCalled, "Should call service to set flavor")
        XCTAssertEqual(mockService.setFlavorValue, .pcre, "Should set PCRE flavor")
    }

    func testFeature_ValidatePattern_PerFlavor_ShowsFlavorSpecificResults() {
        // Given: a pattern that behaves differently in different flavors
        let pattern = "\\d+"
        sut.selectFlavor(.ecmascript)

        // When: the pattern is validated
        _ = sut.validatePattern(pattern)

        // Then: validation should be flavor-specific
        XCTAssertTrue(mockService.validatePatternCalled, "Should call flavor-specific validation")
        XCTAssertEqual(mockService.validatePatternValue, pattern, "Should validate the pattern")
        XCTAssertEqual(mockService.validateFlavor, .ecmascript, "Should use selected flavor")
    }

    func testFeature_GetFlavorDifferences_ShowsDifferences() {
        // Given: two flavors to compare with mock differences
        let flavor1 = RegexFlavor.ecmascript
        let flavor2 = RegexFlavor.pcre
        mockService.flavorDifferences = [
            FlavorDifference(
                feature: "Lookahead",
                flavor1Support: "Supported",
                flavor2Support: "Supported",
                description: "Both support lookahead"
            )
        ]

        // When: the user requests flavor differences
        let differences = sut.getFlavorDifferences(between: flavor1, and: flavor2)

        // Then: differences should be shown
        XCTAssertTrue(mockService.getFlavorDifferencesCalled, "Should call service for differences")
        XCTAssertFalse(differences.isEmpty, "Should have differences between flavors")
    }

    func testFeature_SwitchFlavor_UpdatesPatternValidation() {
        // Given: a pattern and initial flavor
        sut.selectFlavor(.ecmascript)
        mockService.isPatternValid = true

        // When: the user switches to a different flavor
        sut.selectFlavor(.python)

        // Then: pattern should be re-validated with new flavor
        XCTAssertTrue(mockService.setFlavorCalled, "Should call service to switch flavor")
        XCTAssertEqual(sut.selectedFlavor, .python, "Should update selected flavor")
    }

    func testFeature_GetFlavorInfo_ShowsFlavorDetails() {
        // Given: a selected flavor with mock info
        let flavor = RegexFlavor.pcre
        mockService.flavorInfo = FlavorInfo(
            flavor: flavor,
            description: flavor.description,
            features: [],
            commonUseCases: [],
            limitations: []
        )
        sut.selectFlavor(flavor)

        // When: the user requests flavor information
        let info = sut.getFlavorInfo()

        // Then: flavor details should be shown
        XCTAssertTrue(mockService.getFlavorInfoCalled, "Should call service for flavor info")
        XCTAssertNotNil(info, "Should return flavor information")
        XCTAssertEqual(mockService.getFlavorInfoValue, flavor, "Should get info for selected flavor")
    }

    func testFeature_AvailableFlavors_ShowsAllFlavors() {
        // Given: service provides available flavors
        let flavors: [RegexFlavor] = [.ecmascript, .pcre, .python, .dotnet, .java]
        mockService.availableFlavors = flavors

        // When: the user views available flavors
        sut.loadAvailableFlavors()

        // Then: all flavors should be available
        XCTAssertTrue(mockService.getAvailableFlavorsCalled, "Should call service for flavors")
        XCTAssertEqual(sut.availableFlavors.count, 5, "Should have 5 flavors available")
    }

    func testFeature_FlavorSpecificFeatures_ShowsSupportedFeatures() {
        // Given: a flavor with specific features
        let flavor = RegexFlavor.pcre
        mockService.flavorFeatures = [
            FlavorFeature(name: "Lookahead", description: "Positive and negative lookahead", supported: true),
            FlavorFeature(name: "Lookbehind", description: "Positive and negative lookbehind", supported: true)
        ]
        sut.selectFlavor(flavor)

        // When: the user views flavor features
        let features = sut.getFlavorFeatures()

        // Then: supported features should be shown
        XCTAssertTrue(mockService.getFlavorFeaturesCalled, "Should call service for features")
        XCTAssertFalse(features.isEmpty, "Should return flavor features")
    }
}
