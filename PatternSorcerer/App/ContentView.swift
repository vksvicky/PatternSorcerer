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
            Section("Main") {
                NavigationLink(value: AppState.Feature.regexTester) {
                    Label("Regex Tester", systemImage: "magnifyingglass")
                }
                
                NavigationLink(value: AppState.Feature.patternBuilder) {
                    Label("Pattern Builder", systemImage: "slider.horizontal.3")
                }
                
                NavigationLink(value: AppState.Feature.patternLibrary) {
                    Label("Pattern Library", systemImage: "book")
                }
            }
            
            Section("Tools") {
                NavigationLink(value: AppState.Feature.codeExport) {
                    Label("Code Export", systemImage: "doc.text")
                }
                
                NavigationLink(value: AppState.Feature.performance) {
                    Label("Performance", systemImage: "speedometer")
                }
            }
            
            Section("Learn") {
                NavigationLink(value: AppState.Feature.tutorials) {
                    Label("Tutorials", systemImage: "graduationcap")
                }
            }
        }
        .navigationTitle("PatternSorcerer")
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
        Text("Pattern Builder")
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct PatternLibraryView: View {
    var body: some View {
        Text("Pattern Library")
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct CodeExportView: View {
    var body: some View {
        Text("Code Export")
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct TutorialView: View {
    var body: some View {
        Text("Tutorials")
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct PerformanceView: View {
    var body: some View {
        Text("Performance Analytics")
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}


