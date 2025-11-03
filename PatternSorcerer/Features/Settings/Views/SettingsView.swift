//
//  SettingsView.swift
//  PatternSorcerer
//
//  Settings view with theme customization
//
//  Created on $(date)
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var themeManager = ThemeManager()
    @AppStorage("autoValidatePattern") private var autoValidate = true
    @AppStorage("showLineNumbers") private var showLineNumbers = true
    @AppStorage("fontSize") private var fontSize: Double = 13
    @AppStorage("enableNotifications") private var enableNotifications = false

    var body: some View {
        TabView {
            GeneralSettingsView(themeManager: themeManager)
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            AppearanceSettingsView(themeManager: themeManager)
                .tabItem {
                    Label("Appearance", systemImage: "paintbrush")
                }

            EditorSettingsView(
                autoValidate: $autoValidate,
                showLineNumbers: $showLineNumbers,
                fontSize: $fontSize
            )
            .tabItem {
                Label("Editor", systemImage: "textformat")
            }

            AdvancedSettingsView(enableNotifications: $enableNotifications)
                .tabItem {
                    Label("Advanced", systemImage: "slider.horizontal.3")
                }
        }
        .frame(width: 600, height: 400)
    }
}

// MARK: - General Settings
struct GeneralSettingsView: View {
    @ObservedObject var themeManager: ThemeManager

    var body: some View {
        Form {
            Section("Startup") {
                Toggle("Open last pattern on launch", isOn: .constant(false))
                Toggle("Check for updates automatically", isOn: .constant(true))
            }

            Section("Patterns") {
                Picker("Default Pattern Category", selection: .constant(PatternCategory.general)) {
                    ForEach(PatternCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
            }

            Section("Notifications") {
                Toggle("Enable notifications", isOn: .constant(false))
            }
        }
        .padding()
    }
}

// MARK: - Appearance Settings
struct AppearanceSettingsView: View {
    @ObservedObject var themeManager: ThemeManager

    var body: some View {
        Form {
            Section("Theme") {
                Picker("App Theme", selection: $themeManager.currentTheme) {
                    ForEach(AppTheme.allCases) { theme in
                        HStack {
                            Circle()
                                .fill(theme.accentColor)
                                .frame(width: 16, height: 16)
                            Text(theme.rawValue)
                        }
                        .tag(theme)
                    }
                }
                .pickerStyle(.radioGroup)
                .onChange(of: themeManager.currentTheme) { oldTheme, newTheme in
                    themeManager.applyTheme(newTheme)
                }
            }

            Section("Colors") {
                ColorPicker("Accent Color", selection: $themeManager.accentColor)
            }

            Section("Preview") {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Theme Preview")
                            .font(.headline)
                        Text("This is how your app will look")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(themeManager.currentTheme.primaryColor.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

// MARK: - Editor Settings
struct EditorSettingsView: View {
    @Binding var autoValidate: Bool
    @Binding var showLineNumbers: Bool
    @Binding var fontSize: Double

    var body: some View {
        Form {
            Section("Validation") {
                Toggle("Auto-validate patterns", isOn: $autoValidate)
                Toggle("Show validation errors inline", isOn: .constant(true))
            }

            Section("Display") {
                Toggle("Show line numbers", isOn: $showLineNumbers)

                VStack(alignment: .leading) {
                    Text("Font Size: \(Int(fontSize))")
                    Slider(value: $fontSize, in: 10...20, step: 1)
                }
            }

            Section("Behavior") {
                Picker("Tab Size", selection: .constant(4)) {
                    Text("2 spaces").tag(2)
                    Text("4 spaces").tag(4)
                    Text("Tab").tag(-1)
                }
            }
        }
        .padding()
    }
}

// MARK: - Advanced Settings
struct AdvancedSettingsView: View {
    @Binding var enableNotifications: Bool

    var body: some View {
        Form {
            Section("Performance") {
                Toggle("Enable performance analytics", isOn: .constant(false))
                Toggle("Cache compiled patterns", isOn: .constant(true))
            }

            Section("Data") {
                Button("Export All Patterns") {
                    // TODO: Implement export
                }

                Button("Import Patterns") {
                    // TODO: Implement import
                }

                Button("Clear Cache") {
                    // TODO: Implement clear cache
                }
            }

            Section("Debug") {
                Toggle("Enable debug logging", isOn: .constant(false))
                Button("Show Logs") {
                    // TODO: Show log viewer
                }
            }
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}

