//
//  ContentView.swift
//  PatternSorcerer
//
//  Created on $(date)
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            MainContentView()
        }
        .frame(minWidth: 1000, minHeight: 600)
    }
}

// MARK: - Sidebar
struct SidebarView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        List(selection: $appState.selectedFeature) {
            Section(LocalizedString.sidebarMain) {
                NavigationLink(value: AppState.Feature.regexTester) {
                    Label(LocalizedString.sidebarRegexTester, systemImage: "magnifyingglass")
                }

                NavigationLink(value: AppState.Feature.patternBuilder) {
                    Label(LocalizedString.sidebarPatternBuilder, systemImage: "slider.horizontal.3")
                }

                NavigationLink(value: AppState.Feature.patternLibrary) {
                    Label(LocalizedString.sidebarPatternLibrary, systemImage: "book")
                }
            }

            Section(LocalizedString.sidebarTools) {
                NavigationLink(value: AppState.Feature.codeExport) {
                    Label(LocalizedString.sidebarCodeExport, systemImage: "doc.text")
                }

                NavigationLink(value: AppState.Feature.performance) {
                    Label(LocalizedString.sidebarPerformance, systemImage: "speedometer")
                }
            }

            Section(LocalizedString.sidebarLearn) {
                NavigationLink(value: AppState.Feature.tutorials) {
                    Label(LocalizedString.sidebarTutorials, systemImage: "graduationcap")
                }
            }
        }
        .navigationTitle(LocalizedString.sidebarTitle)
    }
}

// MARK: - Main Content
struct MainContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            switch appState.selectedFeature {
            case .regexTester:
                RegexTesterView()
            case .patternBuilder:
                PatternBuilderView()
            case .patternLibrary:
                PatternLibraryView()
            case .codeExport:
                CodeExportView()
            case .tutorials:
                TutorialView()
            case .performance:
                PerformanceView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Placeholder Views
struct PatternBuilderView: View {
    var body: some View {
        Text(LocalizedString.placeholderPatternBuilder)
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct PatternLibraryView: View {
    var body: some View {
        Text(LocalizedString.placeholderPatternLibrary)
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct CodeExportView: View {
    var body: some View {
        Text(LocalizedString.placeholderCodeExport)
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct TutorialView: View {
    var body: some View {
        Text(LocalizedString.placeholderTutorials)
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct PerformanceView: View {
    var body: some View {
        Text(LocalizedString.placeholderPerformance)
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

