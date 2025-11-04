//
//  Logger.swift
//  PatternSorcerer
//
//  Centralized logging utility using NSLog
//
//  Created on 2025-11-04
//

import Foundation
import os.log
import SwiftUI

/// Centralized logging utility
class Logger {
    static let shared = Logger()

    private let subsystem = Bundle.main.bundleIdentifier ?? "com.patternsorcerer"
    private let category = "PatternSorcerer"
    private let log: OSLog
    private var storedLogs: [LogEntry] = []
    private let maxLogs = 1000

    private init() {
        log = OSLog(subsystem: subsystem, category: category)
    }

    // MARK: - Log Levels

    /// Log debug information
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[DEBUG] \(fileName):\(line) \(function) - \(message)"
        NSLog("%@", logMessage)
        os_log("%{public}@", log: log, type: .debug, logMessage)
        addLogEntry(level: .debug, message: logMessage)
    }

    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.debug(message, file: file, function: function, line: line)
    }

    /// Log informational messages
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[INFO] \(fileName):\(line) \(function) - \(message)"
        NSLog("%@", logMessage)
        os_log("%{public}@", log: log, type: .info, logMessage)
        addLogEntry(level: .info, message: logMessage)
    }

    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.info(message, file: file, function: function, line: line)
    }

    /// Log warning messages
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[WARNING] \(fileName):\(line) \(function) - \(message)"
        NSLog("%@", logMessage)
        os_log("%{public}@", log: log, type: .default, logMessage)
        addLogEntry(level: .warning, message: logMessage)
    }

    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.warning(message, file: file, function: function, line: line)
    }

    /// Log error messages
    func error(_ message: String, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        var logMessage = "[ERROR] \(fileName):\(line) \(function) - \(message)"
        if let error = error {
            logMessage += " | Error: \(error.localizedDescription)"
        }
        NSLog("%@", logMessage)
        os_log("%{public}@", log: log, type: .error, logMessage)
        addLogEntry(level: .error, message: logMessage)
    }

    static func error(_ message: String, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        shared.error(message, error: error, file: file, function: function, line: line)
    }

    // MARK: - Log Storage

    private func addLogEntry(level: LogLevel, message: String) {
        storedLogs.append(LogEntry(timestamp: Date(), level: level, message: message))
        if storedLogs.count > maxLogs {
            storedLogs.removeFirst()
        }
    }

    func getLogs() -> [LogEntry] {
        storedLogs
    }

    func clearLogs() {
        storedLogs.removeAll()
    }
}

// MARK: - Log Models

struct LogEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let level: LogLevel
    let message: String
}

enum LogLevel: String {
    case info = "INFO"
    case warning = "WARN"
    case error = "ERROR"
    case debug = "DEBUG"

    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        case .debug: return .gray
        }
    }
}
