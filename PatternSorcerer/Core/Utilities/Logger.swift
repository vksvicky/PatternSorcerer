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

/// Centralized logging utility
enum Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.patternsorcerer"
    private static let category = "PatternSorcerer"

    private static let log = OSLog(subsystem: subsystem, category: category)

    // MARK: - Log Levels

    /// Log debug information
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[DEBUG] \(fileName):\(line) \(function) - \(message)"
        NSLog("%@", logMessage)
        os_log("%{public}@", log: log, type: .debug, logMessage)
    }

    /// Log informational messages
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[INFO] \(fileName):\(line) \(function) - \(message)"
        NSLog("%@", logMessage)
        os_log("%{public}@", log: log, type: .info, logMessage)
    }

    /// Log warning messages
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[WARNING] \(fileName):\(line) \(function) - \(message)"
        NSLog("%@", logMessage)
        os_log("%{public}@", log: log, type: .default, logMessage)
    }

    /// Log error messages
    static func error(_ message: String, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        var logMessage = "[ERROR] \(fileName):\(line) \(function) - \(message)"
        if let error = error {
            logMessage += " | Error: \(error.localizedDescription)"
        }
        NSLog("%@", logMessage)
        os_log("%{public}@", log: log, type: .error, logMessage)
    }
}
