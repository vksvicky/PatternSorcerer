//
//  LogViewerView.swift
//  PatternSorcerer
//
//  View for displaying application logs
//
//  Created on 2025-11-04
//

import SwiftUI

struct LogViewerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var logViewModel = LogViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if logViewModel.logs.isEmpty {
                    Text(LocalizedString.logsEmpty)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(logViewModel.logs, id: \.id) { logEntry in
                                LogEntryView(entry: logEntry)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(LocalizedString.settingsShowLogs)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.commonClose) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(LocalizedString.logsClear) {
                        logViewModel.clearLogs()
                    }
                }
            }
        }
        .frame(width: 800, height: 600)
    }
}

struct LogEntryView: View {
    let entry: LogEntry

    var body: some View {
        HStack(alignment: .top) {
            Text(entry.timestamp, style: .time)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)

            Text(entry.level.rawValue)
                .font(.caption)
                .foregroundColor(entry.level.color)
                .frame(width: 60, alignment: .leading)

            Text(entry.message)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}

@MainActor
class LogViewModel: ObservableObject {
    @Published var logs: [LogEntry] = []

    init() {
        loadLogs()
    }

    func loadLogs() {
        logs = Logger.shared.getLogs()
    }

    func clearLogs() {
        Logger.shared.clearLogs()
        logs = []
    }
}
