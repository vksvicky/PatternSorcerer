//
//  RegexDebuggerServiceProtocol.swift
//  PatternSorcerer
//
//  Protocol for regex debugging service operations
//
//  Created on 2024-12-XX
//

import Foundation

/// Protocol for regex debugging service operations
protocol RegexDebuggerServiceProtocol {
    /// Start debugging a pattern against text
    /// - Parameters:
    ///   - pattern: The regex pattern to debug
    ///   - text: The text to match against
    /// - Returns: Array of debug steps representing the execution
    /// - Throws: Error if debugging fails
    func startDebugging(pattern: String, text: String) throws -> [RegexDebugStep]

    /// Stop debugging
    func stopDebugging()

    /// Get the current debug step
    /// - Returns: Current step or nil if not debugging
    func getCurrentStep() -> RegexDebugStep?

    /// Get a specific step by index
    /// - Parameter index: Step index (0-based)
    /// - Returns: Step at index or nil if invalid
    func getStep(at index: Int) -> RegexDebugStep?

    /// Get total number of steps
    /// - Returns: Total step count
    func getTotalSteps() -> Int

    /// Check if backtracking occurred
    /// - Returns: True if any step involved backtracking
    func hasBacktracking() -> Bool
}
