//
//  CodeExportView.swift
//  PatternSorcerer
//
//  SwiftUI view for Code Export feature
//
//  Created on 2025-11-04
//

import SwiftUI
import UniformTypeIdentifiers

struct CodeExportView: View {
    @StateObject private var viewModel = CodeExportViewModel()
    @State private var showFileSaveDialog = false
    @State private var showCopyConfirmation = false

    var body: some View {
        VStack(spacing: 16) {
            // Header
            headerSection

            // Input Section
            inputSection

            // Options Section
            optionsSection

            // Export Actions
            exportActionsSection

            // Output Section
            outputSection
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Error", isPresented: .constant(viewModel.exportError != nil)) {
            Button("OK") {
                viewModel.exportError = nil
            }
        } message: {
            if let error = viewModel.exportError {
                Text(error.localizedDescription)
            }
        }
        .fileExporter(
            isPresented: $showFileSaveDialog,
            document: CodeExportDocument(code: viewModel.exportedCode),
            contentType: .plainText,
            defaultFilename: "regex_pattern.\(viewModel.selectedLanguage.fileExtension)"
        ) { result in
            if case .success(let url) = result {
                viewModel.saveToFile(url: url)
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Code Export")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Export your regex pattern as ready-to-use code in your preferred language")
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
                Text("Pattern")
                    .font(.headline)

                TextField("Enter regex pattern", text: $viewModel.pattern)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
            }

            // Test Text Input
            VStack(alignment: .leading, spacing: 4) {
                Text("Test Text (Optional)")
                    .font(.headline)

                TextField("Enter test text", text: $viewModel.testText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
            }

            // Language Selection
            VStack(alignment: .leading, spacing: 4) {
                Text("Language")
                    .font(.headline)

                Picker("Language", selection: $viewModel.selectedLanguage) {
                    ForEach(CodeLanguage.allCases) { language in
                        Text(language.rawValue).tag(language)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }

    // MARK: - Options Section

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Options")
                .font(.headline)

            Toggle("Case Insensitive", isOn: $viewModel.options.caseInsensitive)
            Toggle("Multiline", isOn: $viewModel.options.multiline)
            Toggle("Dot Matches Newline", isOn: $viewModel.options.dotMatchesNewline)
            Toggle("Allow Comments", isOn: $viewModel.options.allowComments)
            Toggle("Ignore Metacharacters", isOn: $viewModel.options.ignoreMetacharacters)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }

    // MARK: - Export Actions Section

    private var exportActionsSection: some View {
        HStack(spacing: 12) {
            Button("Export Code") {
                viewModel.exportCode()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.pattern.isEmpty)

            Button("Copy to Clipboard") {
                viewModel.copyToClipboard()
                showCopyConfirmation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCopyConfirmation = false
                }
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.exportedCode.isEmpty)

            if showCopyConfirmation {
                Text("Copied!")
                    .foregroundColor(.green)
                    .font(.caption)
                    .transition(.opacity)
            }

            Button("Save to File") {
                showFileSaveDialog = true
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.exportedCode.isEmpty)
        }
    }

    // MARK: - Output Section

    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exported Code")
                .font(.headline)

            if viewModel.exportedCode.isEmpty {
                Text("Exported code will appear here")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(minHeight: 200)
            } else {
                ScrollView {
                    Text(viewModel.exportedCode)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .textSelection(.enabled)
                }
                .frame(minHeight: 200)
            }
        }
        .padding()
        .background(Color(NSColor.textBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Code Export Document

private struct CodeExportDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }

    var code: String

    init(code: String) {
        self.code = code
    }

    init(configuration: ReadConfiguration) throws {
        code = ""
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = code.data(using: .utf8) ?? Data()
        return FileWrapper(regularFileWithContents: data)
    }
}

// MARK: - Preview

#Preview {
    CodeExportView()
        .frame(width: 800, height: 900)
}
