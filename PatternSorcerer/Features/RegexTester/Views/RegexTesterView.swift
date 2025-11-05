//
//  RegexTesterView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import SwiftUI

struct RegexTesterView: View {
    @StateObject private var viewModel = RegexTesterViewModel()
    @State private var selectedTab: ResultsTab = .matches

    enum ResultsTab: String, CaseIterable {
        case matches
        case explanation
        case complexity
        case backtracking

        var localizedTitle: String {
            switch self {
            case .matches: return LocalizedString.tabsMatches
            case .explanation: return LocalizedString.tabsExplanation
            case .complexity: return LocalizedString.tabsComplexity
            case .backtracking: return LocalizedString.tabsBacktracking
            }
        }
    }

    var body: some View {
        HSplitView {
            // Left side: Pattern and Test Text
            VStack(spacing: 12) {
                SectionContainer(
                    title: "Pattern",
                    description: "Enter your regular expression pattern here"
                ) {
                    PatternInputView(viewModel: viewModel)
                }

                Divider()

                SectionContainer(
                    title: "Test Text",
                    description: "Enter the text you want to test against the pattern"
                ) {
                    TestTextView(viewModel: viewModel)
                }
            }
            .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)

            // Right side: Results with Tabs
            VStack(spacing: 12) {
                // Tab selector
                Picker("View", selection: $selectedTab) {
                    ForEach(ResultsTab.allCases, id: \.self) { tab in
                        Text(tab.localizedTitle).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Divider()

                // Tab content
                SectionContainer(title: selectedTab.localizedTitle) {
                    switch selectedTab {
                    case .matches:
                        ResultsView(viewModel: viewModel)
                    case .explanation:
                        ExplanationView(viewModel: viewModel)
                    case .complexity:
                        ComplexityView(viewModel: viewModel)
                    case .backtracking:
                        BacktrackingView(viewModel: viewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 800, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
    }
}

// MARK: - Pattern Input View
struct PatternInputView: View {
    @ObservedObject var viewModel: RegexTesterViewModel
    @StateObject private var flavorViewModel = RegexFlavorViewModel()
    @State private var showFlavorInfo = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(LocalizedString.regexTesterPattern)
                    .font(.headline)

                Spacer()

                // Complexity indicator
                if let score = viewModel.complexityScore, viewModel.isPatternValid {
                    HStack(spacing: 4) {
                        Image(systemName: "gauge")
                            .foregroundColor(score.level.color)
                        Text("\(score.score)")
                            .font(.caption)
                            .foregroundColor(score.level.color)
                    }
                }

                if !viewModel.isPatternValid {
                    Label(LocalizedString.regexTesterInvalid, systemImage: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                } else if !viewModel.pattern.isEmpty {
                    Label(LocalizedString.regexTesterValid, systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                TextField(LocalizedString.regexTesterEnterPattern, text: $viewModel.pattern)
                    .font(.system(.body, design: .monospaced))
                    .textFieldStyle(.roundedBorder)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(viewModel.isPatternValid ? Color.clear : Color.red, lineWidth: 1)
                    )

                // Syntax highlighting preview
                if !viewModel.pattern.isEmpty && viewModel.isPatternValid {
                    SyntaxHighlightedPatternView(pattern: viewModel.pattern)
                        .frame(height: 20)
                }
            }

            if let error = viewModel.validationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }

            // Regex Flavor Selector
            RegexFlavorSelectorView(viewModel: flavorViewModel)

            // Options
            RegexOptionsView(options: $viewModel.regexOptions)
        }
        .padding()
        .sheet(isPresented: $showFlavorInfo) {
            if let info = flavorViewModel.flavorInfo {
                FlavorInfoSheet(flavorInfo: info, isPresented: $showFlavorInfo)
            }
        }
    }
}

// MARK: - Test Text View
struct TestTextView: View {
    @ObservedObject var viewModel: RegexTesterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(LocalizedString.regexTesterTestText)
                    .font(.headline)

                Spacer()

                Button(LocalizedString.regexTesterClear) {
                    viewModel.clearTestText()
                }
                .buttonStyle(.borderless)
            }

            // Use HighlightedTextView if we have highlights, otherwise use LineNumberTextView
            if let highlightedText = viewModel.highlightedText {
                HighlightedTextView(
                    text: $viewModel.testText,
                    highlightedText: highlightedText,
                    showLineNumbers: true,
                    fontSize: 13
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            } else {
                LineNumberTextView(
                    text: $viewModel.testText,
                    showLineNumbers: .constant(true),
                    fontSize: 13
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding()
    }
}

// MARK: - Results View
struct ResultsView: View {
    @ObservedObject var viewModel: RegexTesterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(LocalizedString.regexTesterResults)
                    .font(.headline)

                Spacer()

                let matchText = viewModel.matches.count == 1
                    ? LocalizedString.regexTesterMatch
                    : LocalizedString.regexTesterMatches
                Text("\(viewModel.matches.count) \(matchText)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if viewModel.matches.isEmpty {
                emptyStateView(
                    icon: "magnifyingglass",
                    message: LocalizedString.regexTesterNoMatches
                )
            } else {
                List(viewModel.matches) { match in
                    MatchRowView(match: match)
                }
                .listStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Match Row View
struct MatchRowView: View {
    let match: MatchResult

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Match #\(match.matchNumber)")
                    .font(.headline)

                Spacer()

                Text(LocalizedString.regexTesterPosition(match.range.location))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(match.matchedText)
                .font(.system(.body, design: .monospaced))
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)

            if !match.captureGroups.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    Text(LocalizedString.regexTesterCaptureGroups)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ForEach(match.captureGroups) { group in
                        HStack {
                            Text(LocalizedString.regexTesterGroup(group.index))
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text(group.text)
                                .font(.system(.caption, design: .monospaced))
                        }
                        .padding(.leading, 16)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Regex Options View
struct RegexOptionsView: View {
    @Binding var options: RegexOptions

    var body: some View {
        DisclosureGroup(LocalizedString.optionsTitle) {
            Toggle(LocalizedString.optionsCaseInsensitive, isOn: $options.caseInsensitive)
            Toggle(LocalizedString.optionsAllowComments, isOn: $options.allowCommentsAndWhitespace)
            Toggle(LocalizedString.optionsIgnoreMetacharacters, isOn: $options.ignoreMetacharacters)
            Toggle(LocalizedString.optionsDotMatchesLines, isOn: $options.dotMatchesLineSeparators)
        }
        .font(.caption)
    }
}

// MARK: - Explanation View
struct ExplanationView: View {
    @ObservedObject var viewModel: RegexTesterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let explanation = viewModel.patternExplanation {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Summary
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Summary")
                                .font(.headline)
                            Text(explanation.summary)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)

                        Divider()

                        // Detailed explanation
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Pattern Breakdown")
                                .font(.headline)

                            ForEach(Array(explanation.parts.enumerated()), id: \.offset) { _, part in
                                HStack(alignment: .top, spacing: 12) {
                                    Text(part.text)
                                        .font(.system(.body, design: .monospaced))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(4)
                                        .frame(minWidth: 60)

                                    Text(part.explanation)
                                        .font(.body)
                                        .foregroundColor(.secondary)

                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                    }
                }
            } else {
                emptyStateView(
                    icon: "text.bubble",
                    message: "Enter a valid pattern to see explanation"
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Complexity View
struct ComplexityView: View {
    @ObservedObject var viewModel: RegexTesterViewModel
    @State private var suggestions: [OptimizationSuggestion] = []
    private let complexityAnalyzer = PatternComplexityAnalyzer()

    init(viewModel: RegexTesterViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let score = viewModel.complexityScore {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Complexity Score
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Complexity Score")
                                .font(.headline)

                            HStack {
                                Text("\(score.score)/100")
                                    .font(.system(size: 32, weight: .bold))

                                Spacer()

                                Label(score.level.rawValue, systemImage: "gauge")
                                    .foregroundColor(score.level.color)
                                    .font(.title3)
                            }

                            // Progress bar
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 8)
                                        .cornerRadius(4)

                                    Rectangle()
                                        .fill(score.level.color)
                                        .frame(width: geometry.size.width * CGFloat(score.score) / 100, height: 8)
                                        .cornerRadius(4)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)

                        // Complexity Factors
                        if !score.factors.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Complexity Factors")
                                    .font(.headline)

                                ForEach(score.factors, id: \.self) { factor in
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.orange)
                                        Text(factor.description)
                                            .font(.body)
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .padding()
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                        }

                        // Optimization Suggestions
                        if !suggestions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Optimization Suggestions")
                                    .font(.headline)

                                ForEach(Array(suggestions.enumerated()), id: \.offset) { _, suggestion in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(.yellow)
                                        Text(suggestion.description)
                                            .font(.body)
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .padding()
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                        }
                    }
                }
            } else {
                emptyStateView(
                    icon: "chart.bar",
                    message: "Enter a valid pattern to analyze complexity"
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: viewModel.pattern) { _, newPattern in
            // Update suggestions when pattern changes, deferred outside view update
            DispatchQueue.main.async {
                suggestions = complexityAnalyzer.getOptimizationSuggestions(newPattern)
            }
        }
        .task {
            // Load initial suggestions
            suggestions = complexityAnalyzer.getOptimizationSuggestions(viewModel.pattern)
        }
    }
}

// MARK: - Backtracking View
struct BacktrackingView: View {
    @ObservedObject var viewModel: RegexTesterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let analysis = viewModel.backtrackingAnalysis {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Risk Level
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Backtracking Risk")
                                .font(.headline)

                            HStack {
                                Label(analysis.riskLevel.description, systemImage: "shield.fill")
                                    .foregroundColor(analysis.riskLevel.color)
                                    .font(.title3)

                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)

                        // Warnings
                        if !analysis.warnings.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Warnings")
                                    .font(.headline)

                                ForEach(analysis.warnings, id: \.self) { warning in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                        Text(warning.description)
                                            .font(.body)
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .padding()
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                        }

                        // Suggestions
                        if !analysis.suggestions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Suggestions")
                                    .font(.headline)

                                ForEach(Array(analysis.suggestions.enumerated()), id: \.offset) { _, suggestion in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "arrow.right.circle.fill")
                                            .foregroundColor(.blue)
                                        Text(suggestion)
                                            .font(.body)
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .padding()
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                        }
                    }
                }
            } else {
                emptyStateView(
                    icon: "shield.checkered",
                    message: "Enter pattern and test text to analyze backtracking"
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    RegexTesterView()
        .frame(width: 1200, height: 800)
}
