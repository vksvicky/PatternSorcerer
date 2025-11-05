//
//  ContentView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic

    var body: some View {
        ResizableSidebarSplit(
            minSidebarWidth: 300,
            maxSidebarWidth: 450,
            initialSidebarWidth: 320
        ) {
            SidebarView()
        } content: {
            MainContentView()
        }
        .frame(minWidth: 1200, minHeight: 700)
        .onAppear {
            #if os(macOS)
            DispatchQueue.main.async {
                if let window = NSApplication.shared.keyWindow ?? NSApplication.shared.windows.first {
                    let minSize = NSSize(width: 1200, height: 700)
                    window.minSize = minSize
                    if window.frame.width < minSize.width || window.frame.height < minSize.height {
                        var frame = window.frame
                        frame.size.width = max(frame.size.width, minSize.width)
                        frame.size.height = max(frame.size.height, minSize.height)
                        window.setFrame(frame, display: true)
                    }
                }
            }
            #endif
        }
    }
}

// MARK: - Sidebar
struct SidebarView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text(LocalizedString.sidebarTitle)
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                Spacer()
            }
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    sectionHeader(LocalizedString.sidebarMain)
                    item(
                        icon: "magnifyingglass",
                        text: LocalizedString.sidebarRegexTester,
                        isSelected: appState.selectedFeature == .regexTester
                    ) {
                        appState.selectedFeature = .regexTester
                    }
                    item(
                        icon: "arrow.stepforward",
                        text: "Regex Debugger",
                        isSelected: appState.selectedFeature == .regexDebugger
                    ) {
                        appState.selectedFeature = .regexDebugger
                    }
                    item(
                        icon: "slider.horizontal.3",
                        text: LocalizedString.sidebarPatternBuilder,
                        isSelected: appState.selectedFeature == .patternBuilder
                    ) {
                        appState.selectedFeature = .patternBuilder
                    }
                    item(
                        icon: "book",
                        text: LocalizedString.sidebarPatternLibrary,
                        isSelected: appState.selectedFeature == .patternLibrary
                    ) {
                        appState.selectedFeature = .patternLibrary
                    }

                    sectionHeader(LocalizedString.sidebarTools)
                    item(
                        icon: "doc.text",
                        text: LocalizedString.sidebarCodeExport,
                        isSelected: appState.selectedFeature == .codeExport
                    ) {
                        appState.selectedFeature = .codeExport
                    }
                    item(
                        icon: "checkmark.circle.badge",
                        text: LocalizedString.sidebarTestSuite,
                        isSelected: appState.selectedFeature == .testSuite
                    ) {
                        appState.selectedFeature = .testSuite
                    }
                    item(
                        icon: "wrench.and.screwdriver",
                        text: LocalizedString.sidebarProfessionalTools,
                        isSelected: appState.selectedFeature == .professionalTools
                    ) {
                        appState.selectedFeature = .professionalTools
                    }
                    item(
                        icon: "speedometer",
                        text: LocalizedString.sidebarPerformance,
                        isSelected: appState.selectedFeature == .performance
                    ) {
                        appState.selectedFeature = .performance
                    }

                    sectionHeader(LocalizedString.sidebarLearn)
                    item(
                        icon: "graduationcap",
                        text: LocalizedString.sidebarTutorials,
                        isSelected: appState.selectedFeature == .tutorials
                    ) {
                        appState.selectedFeature = .tutorials
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
    }

    private func item(icon: String, text: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .frame(width: 20, height: 20)
                    .foregroundColor(isSelected ? .accentColor : .primary)

                Text(text)
                    .foregroundColor(isSelected ? .accentColor : .primary)
                    .fixedSize(horizontal: true, vertical: false)
                    .layoutPriority(1)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(height: 32)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isSelected ? Color.accentColor.opacity(0.1) : Color.clear
            )
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
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
            case .regexDebugger:
                RegexDebuggerView()
            case .patternBuilder:
                PatternBuilderView()
            case .patternLibrary:
                PatternLibraryView()
            case .codeExport:
                CodeExportView()
            case .testSuite:
                TestSuiteManagerView()
            case .professionalTools:
                ProfessionalToolsView()
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

// PatternLibraryView is now in PatternSorcerer/Features/PatternLibrary/Views/PatternLibraryView.swift

// CodeExportView is now in PatternSorcerer/Features/CodeExport/Views/CodeExportView.swift

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
