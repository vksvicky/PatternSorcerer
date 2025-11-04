//
//  ReplaceToolViewModel.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import Combine
import Foundation

@MainActor
class ReplaceToolViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var pattern: String = ""
    @Published var inputText: String = ""
    @Published var replacementText: String = ""
    @Published var outputText: String = ""
    @Published var options = ReplaceOptions()
    @Published var error: String?
    @Published var copyToClipboardCalled = false

    // MARK: - Private Properties

    private let regexEngine: RegexEngineProtocol

    // MARK: - Initialization

    init(regexEngine: RegexEngineProtocol = RegexEngine()) {
        self.regexEngine = regexEngine
    }

    // MARK: - Public Methods

    func performReplace() {
        guard !pattern.isEmpty else {
            error = "Pattern cannot be empty"
            return
        }

        guard !inputText.isEmpty else {
            outputText = ""
            error = nil
            return
        }

        error = nil

        do {
            let regexOptions = options.toNSRegularExpressionOptions()
            let result = try regexEngine.replace(
                pattern: pattern,
                in: inputText,
                with: replacementText,
                options: regexOptions
            )
            outputText = result
            Logger.info("Replace completed: \(pattern)")
        } catch {
            self.error = "Replace failed: \(error.localizedDescription)"
            Logger.error("Replace failed: \(error.localizedDescription)")
            outputText = ""
        }
    }

    func copyToClipboard() {
        copyToClipboardCalled = true
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(outputText, forType: .string)
        Logger.debug("Copy to clipboard called")
    }

    func clear() {
        pattern = ""
        inputText = ""
        replacementText = ""
        outputText = ""
        error = nil
        options = ReplaceOptions()
    }
}
