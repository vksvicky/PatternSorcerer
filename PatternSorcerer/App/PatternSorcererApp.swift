//
//  PatternSorcererApp.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation
import SwiftData
import SwiftUI

@main
struct PatternSorcererApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.currentTheme.colorScheme)
                .accentColor(themeManager.accentColor)
                .modelContainer(PersistenceController.shared.container)
        }
        .commands {
            // Replace new document with new pattern
            CommandGroup(replacing: .newItem) {
                Button(LocalizedString.menuNewPattern) {
                    appState.createNewPattern()
                }
                .keyboardShortcut("n", modifiers: .command)
            }

            // Standard Edit menu
            // Note: Find functionality is handled automatically by NSTextView
            // The standard Cmd+F and Cmd+Option+F shortcuts work automatically
            CommandGroup(after: .textEditing) {
                // Find functionality is built into NSTextView and works automatically
                // with standard keyboard shortcuts (Cmd+F, Cmd+Option+F)
            }

            // Pattern menu
            PatternSorcererCommands(appState: appState)

            // View menu
            CommandGroup(after: .toolbar) {
                Button(LocalizedString.menuToggleSidebar) {
                    appState.toggleSidebar()
                }
                .keyboardShortcut("s", modifiers: [.command, .control])
            }

            // Window menu
            CommandGroup(after: .windowSize) {
                Button(LocalizedString.menuMinimize) {
                    NSApp.keyWindow?.miniaturize(nil)
                }
                .keyboardShortcut("m", modifiers: .command)
            }

            // Help menu
            CommandGroup(replacing: .help) {
                Button(LocalizedString.menuHelpPatternSorcerer) {
                    NSApp.sendAction(#selector(NSApplication.showHelp(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("?")

                Divider()

                Button(LocalizedString.menuLearnRegex) {
                    appState.navigateToTutorials()
                }

                Divider()

                Button(LocalizedString.menuAbout) {
                    NSApp.orderFrontStandardAboutPanel(nil)
                }
            }
        }

        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var currentPattern: Pattern?
    @Published var selectedFeature: Feature = .regexTester
    @Published var isSidebarVisible: Bool = true

    enum Feature {
        case regexTester
        case patternBuilder
        case patternLibrary
        case codeExport
        case tutorials
        case performance
    }

    // MARK: - Navigation Methods

    func navigateToTutorials() {
        selectedFeature = .tutorials
    }

    func navigateToRegexTester() {
        selectedFeature = .regexTester
    }

    func navigateToCodeExport() {
        selectedFeature = .codeExport
    }

    func navigateToPatternLibrary() {
        selectedFeature = .patternLibrary
    }

    func createNewPattern() {
        // Create a new empty pattern and navigate to regex tester
        currentPattern = Pattern(name: "", pattern: "", patternDescription: "")
        selectedFeature = .regexTester
    }

    func toggleSidebar() {
        isSidebarVisible.toggle()
    }
}

// MARK: - Commands
struct PatternSorcererCommands: Commands {
    @ObservedObject var appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    var body: some Commands {
        CommandMenu(LocalizedString.menuPattern) {
            Button(LocalizedString.menuNewPattern) {
                appState.createNewPattern()
            }
            .keyboardShortcut("n", modifiers: .command)

            Button(LocalizedString.menuOpenPattern) {
                appState.navigateToPatternLibrary()
            }
            .keyboardShortcut("o", modifiers: [.command, .shift])
        }

        CommandMenu(LocalizedString.menuTools) {
            Button(LocalizedString.menuTestRegex) {
                appState.navigateToRegexTester()
            }
            .keyboardShortcut("t", modifiers: .command)

            Button(LocalizedString.menuExportCode) {
                appState.navigateToCodeExport()
            }
            .keyboardShortcut("e", modifiers: [.command, .shift])
        }
    }
}
