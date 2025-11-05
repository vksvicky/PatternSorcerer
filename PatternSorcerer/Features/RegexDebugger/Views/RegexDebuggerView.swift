//
//  RegexDebuggerView.swift
//  PatternSorcerer
//
//  UI for Regex Debugger/Stepper feature
//
//  Created on 2025-12-XX
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

struct RegexDebuggerView: View {
    @StateObject private var viewModel: RegexDebuggerViewModel

    init(
        debuggerService: RegexDebuggerServiceProtocol = RegexDebuggerService(),
        regexEngine: RegexEngineProtocol = RegexEngine()
    ) {
        _viewModel = StateObject(wrappedValue: RegexDebuggerViewModel(
            debuggerService: debuggerService,
            regexEngine: regexEngine
        ))
    }

    var body: some View {
        HSplitView {
            // Left side: Pattern, Test Text, and Controls
            VStack(spacing: 12) {
                SectionContainer(
                    title: "Pattern",
                    description: "Enter your regular expression pattern"
                ) {
                    PatternInputSection(viewModel: viewModel)
                }

                Divider()

                SectionContainer(
                    title: "Test Text",
                    description: "Enter the text to debug against"
                ) {
                    TestTextInputSection(viewModel: viewModel)
                }

                Divider()

                SectionContainer(
                    title: "Debug Controls",
                    description: "Control the debugging session"
                ) {
                    DebugControlsSection(viewModel: viewModel)
                }
            }
            .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)

            // Right side: Step Visualization and List
            VStack(spacing: 12) {
                SectionContainer(
                    title: "Step Visualization",
                    description: "Current step details and position"
                ) {
                    StepVisualizationSection(viewModel: viewModel)
                }

                Divider()

                SectionContainer(
                    title: "All Steps",
                    description: "Step through the execution"
                ) {
                    StepsListSection(viewModel: viewModel)
                }
            }
            .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)
        .alert("Error", isPresented: Binding(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.error = nil } }
        ), presenting: viewModel.error) { _ in
            Button("OK") {
                viewModel.error = nil
            }
        } message: { error in
            Text(error)
        }
    }
}

// MARK: - Pattern Input Section

struct PatternInputSection: View {
    @ObservedObject var viewModel: RegexDebuggerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Enter pattern", text: $viewModel.pattern)
                .font(.system(.body, design: .monospaced))
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.isDebuggingActive)

            if viewModel.isDebuggingActive, let step = viewModel.currentStep {
                HStack {
                    Text("Position: \(step.patternPosition)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    if step.patternPosition < viewModel.pattern.count {
                        let patternIndex = viewModel.pattern.index(
                            viewModel.pattern.startIndex,
                            offsetBy: step.patternPosition
                        )
                        let char = String(viewModel.pattern[patternIndex])
                        Text("Current: '\(char)'")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Test Text Input Section

struct TestTextInputSection: View {
    @ObservedObject var viewModel: RegexDebuggerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextEditor(text: $viewModel.testText)
                .font(.system(.body, design: .monospaced))
                .frame(minHeight: 100)
                .disabled(viewModel.isDebuggingActive)

            if viewModel.isDebuggingActive, let step = viewModel.currentStep {
                HStack {
                    Text("Position: \(step.textPosition)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    if !step.matchedText.isEmpty {
                        Text("Matched: '\(step.matchedText)'")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Debug Controls Section

struct DebugControlsSection: View {
    @ObservedObject var viewModel: RegexDebuggerViewModel

    var body: some View {
        VStack(spacing: 12) {
            // Start/Stop button
            HStack {
                if viewModel.isDebuggingActive {
                    Button(action: viewModel.stopDebugging) {
                        Label("Stop Debugging", systemImage: "stop.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                } else {
                    Button(action: viewModel.startDebugging) {
                        Label("Start Debugging", systemImage: "play.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(viewModel.pattern.isEmpty)
                }
            }

            if viewModel.isDebuggingActive {
                Divider()

                // Navigation controls
                HStack(spacing: 12) {
                    Button(action: viewModel.stepPrevious) {
                        Label("Previous", systemImage: "chevron.left")
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.canStepPrevious)

                    Button(action: viewModel.stepNext) {
                        Label("Next", systemImage: "chevron.right")
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.canStepNext)

                    Spacer()

                    Text("Step \(viewModel.currentStepIndex + 1) of \(viewModel.allSteps.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Status indicators
                HStack {
                    if viewModel.hasBacktracking {
                        Label("Backtracking Detected", systemImage: "arrow.uturn.backward")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }

                    Spacer()

                    if let step = viewModel.currentStep {
                        Label(step.state.rawValue, systemImage: stateIcon(for: step.state))
                            .font(.caption)
                            .foregroundColor(stateColor(for: step.state))
                    }
                }
            }
        }
        .padding()
    }

    private func stateIcon(for state: DebugState) -> String {
        switch state {
        case .matching: return "arrow.right.circle"
        case .matchFound: return "checkmark.circle.fill"
        case .noMatch: return "xmark.circle.fill"
        case .backtracking: return "arrow.uturn.backward"
        case .error: return "exclamationmark.triangle.fill"
        }
    }

    private func stateColor(for state: DebugState) -> Color {
        switch state {
        case .matching: return .blue
        case .matchFound: return .green
        case .noMatch: return .red
        case .backtracking: return .orange
        case .error: return .red
        }
    }
}

// MARK: - Step Visualization Section

struct StepVisualizationSection: View {
    @ObservedObject var viewModel: RegexDebuggerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let step = viewModel.currentStep {
                // Current step details
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Step")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Step Number:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(step.stepNumber)")
                                .font(.body)
                                .fontWeight(.medium)
                        }

                        HStack {
                            Text("Pattern Position:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(step.patternPosition)")
                                .font(.body)
                                .fontWeight(.medium)
                        }

                        HStack {
                            Text("Text Position:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(step.textPosition)")
                                .font(.body)
                                .fontWeight(.medium)
                        }

                        HStack {
                            Text("State:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Label(step.state.rawValue, systemImage: stateIcon(for: step.state))
                                .font(.body)
                                .foregroundColor(stateColor(for: step.state))
                        }

                        if !step.matchedText.isEmpty {
                            Divider()

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Matched Text:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(step.matchedText)
                                    .font(.system(.body, design: .monospaced))
                                    .padding(8)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)

                    Divider()

                    // Description
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(step.description)
                            .font(.body)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                }
            } else {
                emptyStateView(
                    icon: "play.circle",
                    message: "Start debugging to see step details"
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func stateIcon(for state: DebugState) -> String {
        switch state {
        case .matching: return "arrow.right.circle"
        case .matchFound: return "checkmark.circle.fill"
        case .noMatch: return "xmark.circle.fill"
        case .backtracking: return "arrow.uturn.backward"
        case .error: return "exclamationmark.triangle.fill"
        }
    }

    private func stateColor(for state: DebugState) -> Color {
        switch state {
        case .matching: return .blue
        case .matchFound: return .green
        case .noMatch: return .red
        case .backtracking: return .orange
        case .error: return .red
        }
    }
}

// MARK: - Steps List Section

struct StepsListSection: View {
    @ObservedObject var viewModel: RegexDebuggerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.allSteps.isEmpty {
                emptyStateView(
                    icon: "list.bullet",
                    message: "No steps available. Start debugging to see execution steps."
                )
            } else {
                List(viewModel.allSteps) { step in
                    StepRowView(
                        step: step,
                        isSelected: step.id == viewModel.currentStep?.id,
                        onSelect: {
                            if let index = viewModel.allSteps.firstIndex(where: { $0.id == step.id }) {
                                viewModel.jumpToStep(index)
                            }
                        }
                    )
                }
                .listStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Step Row View

struct StepRowView: View {
    let step: RegexDebugStep
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Step \(step.stepNumber)")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Spacer()

                        Label(step.state.rawValue, systemImage: stateIcon(for: step.state))
                            .font(.caption)
                            .foregroundColor(stateColor(for: step.state))
                    }

                    Text(step.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)

                    HStack {
                        Text("Pattern: \(step.patternPosition)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("•")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("Text: \(step.textPosition)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
    }

    private func stateIcon(for state: DebugState) -> String {
        switch state {
        case .matching: return "arrow.right.circle"
        case .matchFound: return "checkmark.circle.fill"
        case .noMatch: return "xmark.circle.fill"
        case .backtracking: return "arrow.uturn.backward"
        case .error: return "exclamationmark.triangle.fill"
        }
    }

    private func stateColor(for state: DebugState) -> Color {
        switch state {
        case .matching: return .blue
        case .matchFound: return .green
        case .noMatch: return .red
        case .backtracking: return .orange
        case .error: return .red
        }
    }
}

#Preview {
    RegexDebuggerView()
        .frame(width: 1200, height: 800)
}
