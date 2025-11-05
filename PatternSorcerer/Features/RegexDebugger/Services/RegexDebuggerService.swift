//
//  RegexDebuggerService.swift
//  PatternSorcerer
//
//  Service for debugging regex pattern execution step-by-step
//
//  Created on 2024-12-XX
//

import Foundation

/// Service for debugging regex pattern execution
final class RegexDebuggerService: RegexDebuggerServiceProtocol {
    // MARK: - Private Properties

    private let regexEngine: RegexEngineProtocol
    private var currentSteps: [RegexDebugStep] = []
    private var currentStepIndex: Int = 0

    // MARK: - Initialization

    init(regexEngine: RegexEngineProtocol = RegexEngine()) {
        self.regexEngine = regexEngine
    }

    // MARK: - RegexDebuggerServiceProtocol

    func startDebugging(pattern: String, text: String) throws -> [RegexDebugStep] {
        // Validate pattern first
        let validation = regexEngine.validatePattern(pattern)
        guard validation.isValid else {
            throw RegexError.invalidPattern(validation.error ?? "Invalid pattern")
        }

        // Perform matching
        let matches = try regexEngine.match(
            pattern: pattern,
            in: text,
            options: []
        )

        // Generate debug steps
        currentSteps = generateDebugSteps(
            pattern: pattern,
            text: text,
            matches: matches
        )
        currentStepIndex = 0

        return currentSteps
    }

    func stopDebugging() {
        currentSteps = []
        currentStepIndex = 0
    }

    func getCurrentStep() -> RegexDebugStep? {
        guard currentStepIndex >= 0 && currentStepIndex < currentSteps.count else {
            return nil
        }
        return currentSteps[currentStepIndex]
    }

    func getStep(at index: Int) -> RegexDebugStep? {
        guard index >= 0 && index < currentSteps.count else {
            return nil
        }
        return currentSteps[index]
    }

    func getTotalSteps() -> Int {
        return currentSteps.count
    }

    func hasBacktracking() -> Bool {
        return currentSteps.contains { $0.state == .backtracking }
    }

    // MARK: - Private Methods

    private func generateDebugSteps(
        pattern: String,
        text: String,
        matches: [MatchResult]
    ) -> [RegexDebugStep] {
        var steps: [RegexDebugStep] = []
        var stepNumber = 1

        // Initial step: Starting
        steps.append(RegexDebugStep(
            stepNumber: stepNumber,
            patternPosition: 0,
            textPosition: 0,
            matchedText: "",
            state: .matching,
            description: "Starting regex matching"
        ))
        stepNumber += 1

        // Generate steps for each match
        if matches.isEmpty {
            // No match found
            steps.append(RegexDebugStep(
                stepNumber: stepNumber,
                patternPosition: pattern.count,
                textPosition: text.count,
                matchedText: "",
                state: .noMatch,
                description: "No matches found in text"
            ))
        } else {
            // Process each match
            for (index, match) in matches.enumerated() {
                let matchStart = match.range.location
                let matchEnd = matchStart + match.range.length

                // Step: Matching at position
                steps.append(RegexDebugStep(
                    stepNumber: stepNumber,
                    patternPosition: 0,
                    textPosition: matchStart,
                    matchedText: "",
                    state: .matching,
                    description: "Matching at text position \(matchStart)"
                ))
                stepNumber += 1

                // Step: Match found
                steps.append(RegexDebugStep(
                    stepNumber: stepNumber,
                    patternPosition: pattern.count,
                    textPosition: matchEnd,
                    matchedText: match.matchedText,
                    state: .matchFound,
                    description: "Match \(index + 1) found: '\(match.matchedText)' at position \(matchStart)"
                ))
                stepNumber += 1
            }
        }

        return steps
    }
}

