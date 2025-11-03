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
                Button("New Pattern") {
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
                Button("Toggle Sidebar") {
                    // TODO: Implement sidebar toggle action
                    // For now, this is a placeholder
                }
                .keyboardShortcut("s", modifiers: [.command, .control])
            }

            // Window menu
            CommandGroup(after: .windowSize) {
                Button("Minimize") {
                    NSApp.keyWindow?.miniaturize(nil)
                }
                .keyboardShortcut("m", modifiers: .command)
            }

            // Help menu
            CommandGroup(replacing: .help) {
                Button("PatternSorcerer Help") {
                    NSApp.sendAction(#selector(NSApplication.showHelp(_:)), to: nil, from: nil)
                }
                .keyboardShortcut("?")

                Divider()

                Button("Learn Regex") {
                    // TODO: Open tutorials
                }

                Divider()

                Button("About PatternSorcerer") {
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
        CommandMenu("Pattern") {
            Button("New Pattern") {
                // TODO: Implement new pattern
            }
            .keyboardShortcut("n", modifiers: .command)

            Button("Open Pattern Library") {
                // TODO: Implement open library
            }
            .keyboardShortcut("o", modifiers: [.command, .shift])
        }

        CommandMenu("Tools") {
            Button("Test Regex") {
                // TODO: Implement test regex
            }
            .keyboardShortcut("t", modifiers: .command)

            Button("Export Code") {
                // TODO: Implement export code
            }
            .keyboardShortcut("e", modifiers: [.command, .shift])
        }
    }
}


