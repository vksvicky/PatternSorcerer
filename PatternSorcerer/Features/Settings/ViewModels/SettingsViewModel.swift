//
//  SettingsViewModel.swift
//  PatternSorcerer
//
//  ViewModel for Settings view
//
//  Created on 2025-11-04
//

import AppKit
import Combine
import Foundation
import SwiftData
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var exportError: Error?
    @Published var importError: Error?
    @Published var clearCacheError: Error?
    @Published var showLogViewer = false

    private let exportImportService: PatternExportImportServiceProtocol
    private let modelContext: ModelContext

    init(
        exportImportService: PatternExportImportServiceProtocol = PatternExportImportService(),
        modelContext: ModelContext
    ) {
        self.exportImportService = exportImportService
        self.modelContext = modelContext
    }

    func exportPatterns() {
        do {
            let descriptor = FetchDescriptor<Pattern>()
            let patterns = try modelContext.fetch(descriptor)

            let savePanel = NSSavePanel()
            savePanel.allowedContentTypes = [.json]
            savePanel.nameFieldStringValue = "patterns_export.json"
            savePanel.title = LocalizedString.settingsExportPatterns

            if savePanel.runModal() == .OK, let url = savePanel.url {
                try exportImportService.exportPatternsToFile(patterns, url: url)
                exportError = nil
            }
        } catch {
            exportError = error
        }
    }

    func importPatterns() {
        do {
            let openPanel = NSOpenPanel()
            openPanel.allowedContentTypes = [.json]
            openPanel.allowsMultipleSelection = false
            openPanel.title = LocalizedString.settingsImportPatterns

            if openPanel.runModal() == .OK, let url = openPanel.url {
                let patterns = try exportImportService.importPatternsFromFile(url: url)
                for pattern in patterns {
                    modelContext.insert(pattern)
                }
                try modelContext.save()
                importError = nil
            }
        } catch {
            importError = error
        }
    }

    func clearCache() {
        do {
            // Clear all cached patterns
            let descriptor = FetchDescriptor<Pattern>()
            let patterns = try modelContext.fetch(descriptor)
            for pattern in patterns {
                modelContext.delete(pattern)
            }
            try modelContext.save()
            clearCacheError = nil
        } catch {
            clearCacheError = error
        }
    }

    func showLogs() {
        showLogViewer = true
    }
}
