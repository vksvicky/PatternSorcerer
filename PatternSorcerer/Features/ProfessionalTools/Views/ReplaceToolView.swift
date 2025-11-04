//
//  ReplaceToolView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import SwiftUI

struct ReplaceToolView: View {
    @StateObject private var viewModel = ReplaceToolViewModel()

    var body: some View {
        VStack(spacing: 16) {
            // Header
            headerSection

            // Input Section
            inputSection

            // Options Section
            optionsSection

            // Actions
            actionsSection

            // Output Section
            outputSection
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Error", isPresented: .constant(viewModel.error != nil), presenting: viewModel.error) { _ in
            Button(LocalizedString.commonClose) {
                viewModel.error = nil
            }
        } message: { error in
            Text(error)
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.replaceToolTitle)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(LocalizedString.replaceToolDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Input Section

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Pattern Input
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedString.replaceToolPattern)
                    .font(.headline)
                TextField(LocalizedString.replaceToolPatternPlaceholder, text: $viewModel.pattern)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
            }

            // Input Text
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedString.replaceToolInputText)
                    .font(.headline)
                TextEditor(text: $viewModel.inputText)
                    .font(.system(.body, design: .monospaced))
                    .frame(height: 150)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    )
            }

            // Replacement Text
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedString.replaceToolReplacement)
                    .font(.headline)
                TextField(LocalizedString.replaceToolReplacementPlaceholder, text: $viewModel.replacementText)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
            }
        }
    }

    // MARK: - Options Section

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.replaceToolOptions)
                .font(.headline)

            Toggle(LocalizedString.optionsCaseInsensitive, isOn: $viewModel.options.caseInsensitive)
            Toggle(LocalizedString.optionsDotMatchesLines, isOn: $viewModel.options.dotMatchesNewline)
            Toggle(LocalizedString.optionsMultiline, isOn: $viewModel.options.multiline)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }

    // MARK: - Actions Section

    private var actionsSection: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.performReplace()
            } label: {
                Label(LocalizedString.replaceToolReplace, systemImage: "arrow.2.squarepath")
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.pattern.isEmpty || viewModel.inputText.isEmpty)

            Button {
                viewModel.copyToClipboard()
            } label: {
                Label(LocalizedString.replaceToolCopy, systemImage: "doc.on.doc")
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.outputText.isEmpty)

            Spacer()

            Button {
                viewModel.clear()
            } label: {
                Label(LocalizedString.replaceToolClear, systemImage: "trash")
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Output Section

    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(LocalizedString.replaceToolOutput)
                    .font(.headline)
                Spacer()
                if !viewModel.outputText.isEmpty {
                    Text("\(viewModel.outputText.count) characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            ScrollView {
                Text(viewModel.outputText)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
            }
            .frame(height: 150)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(NSColor.separatorColor), lineWidth: 1)
            )
            .background(Color(NSColor.textBackgroundColor))
        }
    }
}
