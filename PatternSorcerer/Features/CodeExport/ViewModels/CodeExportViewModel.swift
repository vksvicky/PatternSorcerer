//
//  CodeExportViewModel.swift
//  PatternSorcerer
//
//  ViewModel for Code Export feature
//
//  Created on 2025-11-04
//

import Combine
import Foundation

@MainActor
class CodeExportViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var pattern: String = ""
    @Published var testText: String = ""
    @Published var selectedLanguage: CodeLanguage = .swift
    @Published var options = CodeExportOptions()
    @Published var exportedCode: String = ""
    @Published var exportError: CodeExportError?

    // MARK: - Dependencies

    private let codeExportService: CodeExportServiceProtocol

    // MARK: - Initialization

    init(codeExportService: CodeExportServiceProtocol = CodeExportService()) {
        self.codeExportService = codeExportService
    }

    // MARK: - Actions

    func exportCode() {
        guard !pattern.isEmpty else {
            exportError = .invalidPattern("Pattern cannot be empty")
            exportedCode = ""
            return
        }

        do {
            let code = try codeExportService.exportCode(
                pattern: pattern,
                testText: testText.isEmpty ? nil : testText,
                language: selectedLanguage,
                options: options
            )
            exportedCode = code
            exportError = nil
        } catch let error as CodeExportError {
            exportError = error
            exportedCode = ""
        } catch {
            exportError = .exportFailed(error.localizedDescription)
            exportedCode = ""
        }
    }

    func copyToClipboard() {
        guard !exportedCode.isEmpty else { return }
        codeExportService.copyToClipboard(exportedCode)
    }

    func saveToFile(url: URL) {
        guard !exportedCode.isEmpty else { return }

        do {
            try codeExportService.saveToFile(exportedCode, url: url)
            exportError = nil
        } catch {
            exportError = .fileSaveFailed(url, error)
        }
    }
}
