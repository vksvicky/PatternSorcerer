//
//  PatternSorcererApp.swift
//  PatternSorcerer
//
//  Created on $(date)
//

import SwiftUI
import SwiftData

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
                    // TODO: Implement new pattern action
                    // For now, this is a placeholder
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
            PatternSorcererCommands()

            // View menu
            CommandGroup(after: .toolbar) {
                Button(LocalizedString.menuToggleSidebar) {
                    // TODO: Implement sidebar toggle action
                    // For now, this is a placeholder
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
                    // TODO: Open tutorials
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

    enum Feature {
        case regexTester
        case patternBuilder
        case patternLibrary
        case codeExport
        case tutorials
        case performance
    }
}

// MARK: - Commands
struct PatternSorcererCommands: Commands {
    var body: some Commands {
        CommandMenu(LocalizedString.menuPattern) {
            Button(LocalizedString.menuNewPattern) {
                // TODO: Implement new pattern
            }
            .keyboardShortcut("n", modifiers: .command)

            Button(LocalizedString.menuOpenPattern) {
                // TODO: Implement open library
            }
            .keyboardShortcut("o", modifiers: [.command, .shift])
        }

        CommandMenu(LocalizedString.menuTools) {
            Button(LocalizedString.menuTestRegex) {
                // TODO: Implement test regex
            }
            .keyboardShortcut("t", modifiers: .command)

            Button(LocalizedString.menuExportCode) {
                // TODO: Implement export code
            }
            .keyboardShortcut("e", modifiers: [.command, .shift])
        }
    }
}


