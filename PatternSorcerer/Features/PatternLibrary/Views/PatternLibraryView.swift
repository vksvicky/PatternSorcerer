//
//  PatternLibraryView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import SwiftUI

struct PatternLibraryView: View {
    @StateObject private var viewModel = PatternLibraryViewModel()
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: PatternLibraryTab = .patterns

    enum PatternLibraryTab: String, CaseIterable {
        case patterns
        case reference

        var localizedTitle: String {
            switch self {
            case .patterns: return LocalizedString.patternLibraryCommonPatterns
            case .reference: return LocalizedString.patternLibraryReferenceGuides
            }
        }
    }

    var body: some View {
        HSplitView {
            // Left side: Patterns list
            VStack(spacing: 0) {
                headerSection

                Divider()

                if selectedTab == .patterns {
                    patternsListSection
                } else {
                    referenceSection
                }
            }
            .frame(minWidth: 400)

            Divider()

            // Right side: Pattern details or reference
            VStack(spacing: 0) {
                if selectedTab == .patterns {
                    patternDetailsSection
                } else {
                    referenceDetailsSection
                }
            }
            .frame(minWidth: 400)
        }
        .padding()
        .onAppear {
            viewModel.loadPatterns()
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text(LocalizedString.patternLibraryTitle)
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Picker("View", selection: $selectedTab) {
                    ForEach(PatternLibraryTab.allCases, id: \.self) { tab in
                        Text(tab.localizedTitle).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 250)
            }

            if selectedTab == .patterns {
                searchAndFilterSection
            }
        }
        .padding()
    }

    private var searchAndFilterSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField(LocalizedString.patternLibrarySearch, text: $viewModel.searchText)
            }
            .textFieldStyle(.roundedBorder)

            HStack {
                Text(LocalizedString.patternLibraryFilterByCategory)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Picker(LocalizedString.patternLibraryFilterByCategory, selection: $viewModel.selectedCategory) {
                    Text(LocalizedString.patternLibraryAllCategories).tag(nil as PatternCategory?)
                    ForEach(PatternCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category as PatternCategory?)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 150)
            }
        }
    }

    // MARK: - Patterns List

    private var patternsListSection: some View {
        Group {
            if viewModel.filteredPatterns.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text(LocalizedString.patternLibraryNoPatterns)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $viewModel.selectedPattern) {
                    ForEach(viewModel.filteredPatterns, id: \.id) { pattern in
                        PatternRowView(pattern: pattern)
                            .tag(pattern)
                    }
                }
                .listStyle(.sidebar)
            }
        }
    }

    // MARK: - Pattern Details

    private var patternDetailsSection: some View {
        Group {
            if let pattern = viewModel.selectedPattern {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Name
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pattern.name)
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Divider()

                        // Pattern
                        VStack(alignment: .leading, spacing: 4) {
                            Text(LocalizedString.regexTesterPattern)
                                .font(.headline)
                            Text(pattern.pattern)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(NSColor.controlBackgroundColor))
                                .cornerRadius(8)
                        }

                        Divider()

                        // Description
                        if !pattern.patternDescription.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(LocalizedString.patternLibraryDescription)
                                    .font(.headline)
                                Text(pattern.patternDescription)
                                    .font(.body)
                            }

                            Divider()
                        }

                        // Category
                        VStack(alignment: .leading, spacing: 4) {
                            Text(LocalizedString.patternLibraryCategory)
                                .font(.headline)
                            Text(pattern.category.rawValue)
                                .font(.body)
                        }

                        if !pattern.tags.isEmpty {
                            Divider()

                            VStack(alignment: .leading, spacing: 4) {
                                Text(LocalizedString.patternLibraryTags)
                                    .font(.headline)
                                FlowLayout(spacing: 8) {
                                    ForEach(pattern.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.accentColor.opacity(0.2))
                                            .cornerRadius(4)
                                    }
                                }
                            }
                        }

                        Divider()

                        // Actions
                        HStack {
                            Button {
                                viewModel.selectPattern(pattern)
                                appState.currentPattern = pattern
                                appState.navigateToRegexTester()
                            } label: {
                                Label(LocalizedString.patternLibraryUsePattern, systemImage: "arrow.right.circle")
                            }
                            .buttonStyle(.borderedProminent)

                            Spacer()

                            Button {
                                viewModel.selectPattern(pattern)
                            } label: {
                                Label(LocalizedString.patternLibraryCopyPattern, systemImage: "doc.on.doc")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding()
                }
            } else {
                VStack {
                    Text(LocalizedString.patternLibrarySelectPattern)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    // MARK: - Reference Section

    private var referenceSection: some View {
        List {
            Section(LocalizedString.patternLibraryCharacterClassReference) {
                ForEach(viewModel.characterClassReference) { item in
                    ReferenceRowView(title: item.name, symbol: item.symbol)
                        .tag(item.id)
                }
            }

            Section(LocalizedString.patternLibraryQuantifierCheatSheet) {
                ForEach(viewModel.quantifierCheatSheet) { item in
                    ReferenceRowView(title: item.name, symbol: item.symbol)
                        .tag(item.id)
                }
            }
        }
        .listStyle(.sidebar)
    }

    private var referenceDetailsSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(LocalizedString.patternLibraryReferenceGuides)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Select a reference item from the list to view details")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

// MARK: - Supporting Views

struct PatternRowView: View {
    let pattern: Pattern

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(pattern.name)
                .font(.headline)

            Text(pattern.pattern)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
                .lineLimit(1)

            HStack {
                Text(pattern.category.rawValue)
                    .font(.caption2)
                    .foregroundColor(.secondary)

                if !pattern.tags.isEmpty {
                    Text("•")
                        .foregroundColor(.secondary)
                    Text(pattern.tags.prefix(2).joined(separator: ", "))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct ReferenceRowView: View {
    let title: String
    let symbol: String

    var body: some View {
        HStack {
            Text(symbol)
                .font(.system(.body, design: .monospaced))
                .frame(width: 60, alignment: .leading)

            Text(title)
                .font(.body)
        }
    }
}

// MARK: - Flow Layout Helper

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var frames: [CGRect] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }

            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}
