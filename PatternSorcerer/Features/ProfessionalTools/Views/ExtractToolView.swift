//
//  ExtractToolView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import SwiftUI

struct ExtractToolView: View {
    @StateObject private var viewModel = ExtractToolViewModel()

    var body: some View {
        VStack(spacing: 16) {
            // Header
            headerSection

            // Input Section
            inputSection

            // Group Selection
            groupSelectionSection

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
            Text(LocalizedString.extractToolTitle)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(LocalizedString.extractToolDescription)
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
                Text(LocalizedString.extractToolPattern)
                    .font(.headline)
                TextField(LocalizedString.extractToolPatternPlaceholder, text: $viewModel.pattern)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
            }

            // Input Text
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedString.extractToolInputText)
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

    // MARK: - Group Selection Section

    private var groupSelectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.extractToolGroupSelection)
                .font(.headline)

            Picker(LocalizedString.extractToolGroupIndex, selection: $viewModel.selectedGroupIndex) {
                Text(LocalizedString.extractToolAllGroups).tag(0)
                ForEach(1...10, id: \.self) { index in
                    Text("Group \(index)").tag(index)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }

    // MARK: - Options Section

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.extractToolOptions)
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
                viewModel.performExtract()
            } label: {
                Label(LocalizedString.extractToolExtract, systemImage: "arrow.down.circle")
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.pattern.isEmpty || viewModel.inputText.isEmpty)

            Button {
                viewModel.copyToClipboard()
            } label: {
                Label(LocalizedString.extractToolCopy, systemImage: "doc.on.doc")
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.extractedGroups.isEmpty)

            Spacer()

            Button {
                viewModel.clear()
            } label: {
                Label(LocalizedString.extractToolClear, systemImage: "trash")
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Output Section

    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(LocalizedString.extractToolOutput)
                    .font(.headline)
                Spacer()
                if !viewModel.extractedGroups.isEmpty {
                    Text("\(viewModel.extractedGroups.count) groups")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if viewModel.extractedGroups.isEmpty {
                Text(LocalizedString.extractToolNoOutput)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 150)
            } else {
                List {
                    ForEach(Array(viewModel.extractedGroups.enumerated()), id: \.element.id) { _, group in
                        HStack {
                            Text("Group \(group.index):")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 80, alignment: .leading)
                            Text(group.text)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("(\(group.range.location)-\(group.range.location + group.range.length))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                }
                .frame(height: 150)
            }
        }
    }
}
