//
//  ExtractToolViewModel.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import Combine
import Foundation

@MainActor
class ExtractToolViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var pattern: String = ""
    @Published var inputText: String = ""
    @Published var extractedGroups: [CaptureGroup] = []
    @Published var selectedGroupIndex: Int = 0 // 0 = all groups
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

    func performExtract() {
        guard !pattern.isEmpty else {
            error = "Pattern cannot be empty"
            return
        }

        guard !inputText.isEmpty else {
            extractedGroups = []
            error = nil
            return
        }

        error = nil

        do {
            let regexOptions = options.toNSRegularExpressionOptions()
            let matches = try regexEngine.match(
                pattern: pattern,
                in: inputText,
                options: regexOptions
            )

            var groups: [CaptureGroup] = []
            for match in matches {
                if selectedGroupIndex == 0 {
                    // Extract all groups from all matches
                    groups.append(contentsOf: match.captureGroups)
                } else {
                    // Extract only the selected group index
                    if let group = match.captureGroups.first(where: { $0.index == selectedGroupIndex }) {
                        groups.append(group)
                    }
                }
            }

            extractedGroups = groups
            Logger.info("Extract completed: \(pattern), \(groups.count) groups extracted")
        } catch {
            self.error = "Extract failed: \(error.localizedDescription)"
            Logger.error("Extract failed: \(error.localizedDescription)")
            extractedGroups = []
        }
    }

    func copyToClipboard() {
        copyToClipboardCalled = true
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let outputText = extractedGroups.map { $0.text }.joined(separator: "\n")
        pasteboard.setString(outputText, forType: .string)
        Logger.debug("Copy to clipboard called")
    }

    func clear() {
        pattern = ""
        inputText = ""
        extractedGroups = []
        selectedGroupIndex = 0
        error = nil
        options = ReplaceOptions()
    }
}
