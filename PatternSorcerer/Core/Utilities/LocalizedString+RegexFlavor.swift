//
//  LocalizedString+RegexFlavor.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

// MARK: - Regex Flavor
extension LocalizedString {
    static var regexFlavorTitle: String {
        NSLocalizedString("regex_flavor.title", comment: "Regex Flavor")
    }

    static var regexFlavorSelect: String {
        NSLocalizedString("regex_flavor.select", comment: "Select Flavor")
    }

    static var regexFlavorECMAScript: String {
        NSLocalizedString("regex_flavor.ecmascript", comment: "ECMAScript")
    }

    static var regexFlavorPCRE: String {
        NSLocalizedString("regex_flavor.pcre", comment: "PCRE")
    }

    static var regexFlavorPython: String {
        NSLocalizedString("regex_flavor.python", comment: "Python")
    }

    static var regexFlavorDotNet: String {
        NSLocalizedString("regex_flavor.dotnet", comment: ".NET")
    }

    static var regexFlavorJava: String {
        NSLocalizedString("regex_flavor.java", comment: "Java")
    }

    static var regexFlavorInfo: String {
        NSLocalizedString("regex_flavor.info", comment: "Flavor Information")
    }

    static var regexFlavorFeatures: String {
        NSLocalizedString("regex_flavor.features", comment: "Supported Features")
    }

    static var regexFlavorUseCases: String {
        NSLocalizedString("regex_flavor.use_cases", comment: "Common Use Cases")
    }

    static var regexFlavorLimitations: String {
        NSLocalizedString("regex_flavor.limitations", comment: "Limitations")
    }

    static var regexFlavorDifferences: String {
        NSLocalizedString("regex_flavor.differences", comment: "Flavor Differences")
    }

    static var regexFlavorCompare: String {
        NSLocalizedString("regex_flavor.compare", comment: "Compare Flavors")
    }
}
