//
//  Theme.swift
//  PatternSorcerer
//
//  Theme model for app appearance
//
//  Created on 2025-11-04
//

import Foundation
import SwiftUI

/// App theme configuration
enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    case blue = "Blue"
    case green = "Green"
    case purple = "Purple"

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        case .blue, .green, .purple:
            return nil // These use custom colors
        }
    }

    var primaryColor: Color {
        switch self {
        case .system, .light, .dark:
            return .blue
        case .blue:
            return .blue
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }

    var accentColor: Color {
        switch self {
        case .system, .light, .dark:
            return .accentColor
        case .blue:
            return Color(red: 0.2, green: 0.5, blue: 1.0)
        case .green:
            return Color(red: 0.2, green: 0.8, blue: 0.4)
        case .purple:
            return Color(red: 0.6, green: 0.3, blue: 0.9)
        }
    }
}

/// Theme settings manager
class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "AppTheme")
            Logger.info("Theme changed to: \(currentTheme.rawValue)")
        }
    }

    @Published var accentColor: Color {
        didSet {
            // Save custom accent color if needed
            Logger.debug("Accent color updated")
        }
    }

    init() {
        let savedTheme = UserDefaults.standard.string(forKey: "AppTheme") ?? AppTheme.system.rawValue
        let theme = AppTheme(rawValue: savedTheme) ?? .system
        self.currentTheme = theme
        self.accentColor = theme.accentColor
        Logger.info("Theme initialized: \(theme.rawValue)")
    }

    func applyTheme(_ theme: AppTheme) {
        currentTheme = theme
        accentColor = theme.accentColor
    }
}
