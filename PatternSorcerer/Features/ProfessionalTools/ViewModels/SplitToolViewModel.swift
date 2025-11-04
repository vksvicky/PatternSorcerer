//
//  SplitToolViewModel.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import Combine
import Foundation

@MainActor
class SplitToolViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var pattern: String = ""
    @Published var inputText: String = ""
    @Published var outputParts: [String] = []
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

    func performSplit() {
        guard !pattern.isEmpty else {
            error = "Pattern cannot be empty"
            return
        }

        guard !inputText.isEmpty else {
            outputParts = []
            error = nil
            return
        }

        error = nil

        do {
            let regexOptions = options.toNSRegularExpressionOptions()
            let parts = try regexEngine.split(
                pattern: pattern,
                in: inputText,
                options: regexOptions
            )
            outputParts = parts
            Logger.info("Split completed: \(pattern), \(parts.count) parts")
        } catch {
            self.error = "Split failed: \(error.localizedDescription)"
            Logger.error("Split failed: \(error.localizedDescription)")
            outputParts = []
        }
    }

    func copyToClipboard() {
        copyToClipboardCalled = true
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let outputText = outputParts.joined(separator: "\n")
        pasteboard.setString(outputText, forType: .string)
        Logger.debug("Copy to clipboard called")
    }

    func clear() {
        pattern = ""
        inputText = ""
        outputParts = []
        error = nil
        options = ReplaceOptions()
    }
}
