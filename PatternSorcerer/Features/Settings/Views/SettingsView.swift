//
//  SettingsView.swift
//  PatternSorcerer
//
//  Settings view with theme customization
//
//  Created on 2025-11-04
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
                    Label(LocalizedString.settingsGeneral, systemImage: "gearshape")
                }

            AppearanceSettingsView(themeManager: themeManager)
                .tabItem {
                    Label(LocalizedString.settingsAppearance, systemImage: "paintbrush")
                }

            EditorSettingsView(
                autoValidate: $autoValidate,
                showLineNumbers: $showLineNumbers,
                fontSize: $fontSize
            )
            .tabItem {
                Label(LocalizedString.settingsEditor, systemImage: "textformat")
            }

            AdvancedSettingsView(enableNotifications: $enableNotifications)
                .tabItem {
                    Label(LocalizedString.settingsAdvanced, systemImage: "slider.horizontal.3")
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
            Section(LocalizedString.settingsStartup) {
                Toggle(LocalizedString.settingsOpenLastPattern, isOn: .constant(false))
                Toggle(LocalizedString.settingsCheckUpdates, isOn: .constant(true))
            }

            Section(LocalizedString.settingsPatterns) {
                Picker(LocalizedString.settingsDefaultCategory, selection: .constant(PatternCategory.general)) {
                    ForEach(PatternCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
            }

            Section(LocalizedString.settingsNotifications) {
                Toggle(LocalizedString.settingsEnableNotifications, isOn: .constant(false))
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
            Section(LocalizedString.settingsTheme) {
                Picker(LocalizedString.settingsAppTheme, selection: $themeManager.currentTheme) {
                    ForEach(AppTheme.allCases) { theme in
                        HStack {
                            Circle()
                                .fill(theme.accentColor)
                                .frame(width: 16, height: 16)
                            Text(LocalizedString.themeName(theme.rawValue))
                        }
                        .tag(theme)
                    }
                }
                .pickerStyle(.radioGroup)
                .onChange(of: themeManager.currentTheme) { _, newTheme in
                    themeManager.applyTheme(newTheme)
                }
            }

            Section(LocalizedString.settingsColors) {
                ColorPicker(LocalizedString.settingsAccentColor, selection: $themeManager.accentColor)
            }

            Section(LocalizedString.settingsPreview) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedString.settingsThemePreview)
                            .font(.headline)
                        Text(LocalizedString.settingsThisIsHow)
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
            Section(LocalizedString.settingsValidation) {
                Toggle(LocalizedString.settingsAutoValidate, isOn: $autoValidate)
                Toggle(LocalizedString.settingsShowErrorsInline, isOn: .constant(true))
            }

            Section(LocalizedString.settingsDisplay) {
                Toggle(LocalizedString.settingsShowLineNumbers, isOn: $showLineNumbers)

                VStack(alignment: .leading) {
                    Text(LocalizedString.settingsFontSize(Int(fontSize)))
                    Slider(value: $fontSize, in: 10...20, step: 1)
                }
            }

            Section(LocalizedString.settingsBehavior) {
                Picker(LocalizedString.settingsTabSize, selection: .constant(4)) {
                    Text(LocalizedString.settingsTabSize2).tag(2)
                    Text(LocalizedString.settingsTabSize4).tag(4)
                    Text(LocalizedString.settingsTabSizeTab).tag(-1)
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
            Section(LocalizedString.settingsPerformance) {
                Toggle(LocalizedString.settingsEnableAnalytics, isOn: .constant(false))
                Toggle(LocalizedString.settingsCachePatterns, isOn: .constant(true))
            }

            Section(LocalizedString.settingsData) {
                Button(LocalizedString.settingsExportPatterns) {
                    // TODO: Implement export
                }

                Button(LocalizedString.settingsImportPatterns) {
                    // TODO: Implement import
                }

                Button(LocalizedString.settingsClearCache) {
                    // TODO: Implement clear cache
                }
            }

            Section(LocalizedString.settingsDebug) {
                Toggle(LocalizedString.settingsEnableLogging, isOn: .constant(false))
                Button(LocalizedString.settingsShowLogs) {
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
