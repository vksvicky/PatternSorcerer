//
//  RegexDebuggerViewModel.swift
//  PatternSorcerer
//
//  ViewModel for Regex Debugger/Stepper feature
//
//  Created on 2024-12-XX
//

import Combine
import Foundation

@MainActor
class RegexDebuggerViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var pattern: String = ""
    @Published var testText: String = ""
    @Published var isDebuggingActive: Bool = false
    @Published var currentStep: RegexDebugStep?
    @Published var allSteps: [RegexDebugStep] = []
    @Published var currentStepIndex: Int = 0
    @Published var hasBacktracking: Bool = false
    @Published var error: String?

    // MARK: - Computed Properties

    var currentPatternPosition: Int {
        currentStep?.patternPosition ?? 0
    }

    var currentTextPosition: Int {
        currentStep?.textPosition ?? 0
    }

    var canStepNext: Bool {
        isDebuggingActive && currentStepIndex < allSteps.count - 1
    }

    var canStepPrevious: Bool {
        isDebuggingActive && currentStepIndex > 0
    }

    // MARK: - Dependencies

    private let debuggerService: RegexDebuggerServiceProtocol
    private let regexEngine: RegexEngineProtocol

    // MARK: - Initialization

    init(
        debuggerService: RegexDebuggerServiceProtocol,
        regexEngine: RegexEngineProtocol
    ) {
        self.debuggerService = debuggerService
        self.regexEngine = regexEngine
    }

    // MARK: - Public Methods

    func startDebugging() {
        guard !pattern.isEmpty else {
            error = "Pattern cannot be empty"
            return
        }

        do {
            let steps = try debuggerService.startDebugging(pattern: pattern, text: testText)
            allSteps = steps
            currentStepIndex = 0
            currentStep = steps.first
            isDebuggingActive = true
            hasBacktracking = debuggerService.hasBacktracking()
            error = nil
        } catch {
            self.error = error.localizedDescription
            isDebuggingActive = false
            currentStep = nil
            allSteps = []
        }
    }

    func stopDebugging() {
        debuggerService.stopDebugging()
        isDebuggingActive = false
        currentStep = nil
        allSteps = []
        currentStepIndex = 0
        hasBacktracking = false
        error = nil
    }

    func stepNext() {
        guard canStepNext else { return }

        currentStepIndex += 1
        currentStep = allSteps[currentStepIndex]
    }

    func stepPrevious() {
        guard canStepPrevious else { return }

        currentStepIndex -= 1
        currentStep = allSteps[currentStepIndex]
    }

    func jumpToStep(_ index: Int) {
        guard index >= 0 && index < allSteps.count else { return }
        currentStepIndex = index
        currentStep = allSteps[index]
    }
}

