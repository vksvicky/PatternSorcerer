//
//  SplitToolView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import SwiftUI

struct SplitToolView: View {
    @StateObject private var viewModel = SplitToolViewModel()

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
            Text(LocalizedString.splitToolTitle)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(LocalizedString.splitToolDescription)
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
                Text(LocalizedString.splitToolPattern)
                    .font(.headline)
                TextField(LocalizedString.splitToolPatternPlaceholder, text: $viewModel.pattern)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
            }

            // Input Text
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedString.splitToolInputText)
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
        }
    }

    // MARK: - Options Section

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.splitToolOptions)
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
                viewModel.performSplit()
            } label: {
                Label(LocalizedString.splitToolSplit, systemImage: "scissors")
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.pattern.isEmpty || viewModel.inputText.isEmpty)

            Button {
                viewModel.copyToClipboard()
            } label: {
                Label(LocalizedString.splitToolCopy, systemImage: "doc.on.doc")
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.outputParts.isEmpty)

            Spacer()

            Button {
                viewModel.clear()
            } label: {
                Label(LocalizedString.splitToolClear, systemImage: "trash")
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Output Section

    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(LocalizedString.splitToolOutput)
                    .font(.headline)
                Spacer()
                if !viewModel.outputParts.isEmpty {
                    Text("\(viewModel.outputParts.count) parts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if viewModel.outputParts.isEmpty {
                Text(LocalizedString.splitToolNoOutput)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 150)
            } else {
                List {
                    ForEach(Array(viewModel.outputParts.enumerated()), id: \.offset) { index, part in
                        HStack {
                            Text("\(index + 1).")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 30, alignment: .trailing)
                            Text(part)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 2)
                    }
                }
                .frame(height: 150)
            }
        }
    }
}
