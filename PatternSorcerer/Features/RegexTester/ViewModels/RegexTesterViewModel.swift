//
//  RegexTesterViewModel.swift
//  PatternSorcerer
//
//  Created on $(date)
//

import Foundation
import Combine

@MainActor
class RegexTesterViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var pattern: String = ""
    @Published var testText: String = ""
    @Published var matches: [MatchResult] = []
    @Published var validationError: String?
    @Published var isPatternValid: Bool = true
    @Published var regexOptions: RegexOptions = RegexOptions()

    // MARK: - Unique Features
    @Published var complexityScore: ComplexityScore?
    @Published var patternExplanation: PatternExplanation?
    @Published var backtrackingAnalysis: BacktrackingAnalysis?

    // MARK: - Highlighting
    @Published var highlightedText: HighlightedText?

    // MARK: - Dependencies
    private let regexEngine: RegexEngineProtocol
    private let complexityAnalyzer = PatternComplexityAnalyzer()
    private let explanationGenerator = PatternExplanationGenerator()
    private let backtrackingVisualizer = BacktrackingVisualizer()
    private let matchHighlighter = MatchHighlighter()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(regexEngine: RegexEngineProtocol = RegexEngine()) {
        self.regexEngine = regexEngine
        setupObservers()
    }

    // MARK: - Setup
    private func setupObservers() {
        // Validate pattern when it changes
        $pattern
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] pattern in
                self?.validatePattern(pattern)
            }
            .store(in: &cancellables)

        // Test pattern when pattern or test text changes
        Publishers.CombineLatest($pattern, $testText)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] pattern, text in
                self?.testPattern()
                // Update backtracking analysis when test text changes
                if let self = self, !pattern.isEmpty && self.isPatternValid {
                    self.updateUniqueFeatures(pattern: pattern)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Validation
    func validatePattern(_ pattern: String? = nil) {
        let patternToValidate = pattern ?? self.pattern

        if patternToValidate.isEmpty {
            isPatternValid = true
            validationError = nil
            complexityScore = nil
            patternExplanation = nil
            backtrackingAnalysis = nil
            return
        }

        let result = regexEngine.validatePattern(patternToValidate)
        isPatternValid = result.isValid

        // Format error message for better user experience
        if let error = result.error {
            validationError = ErrorFormatter.format(RegexError.invalidPattern(error))
        } else {
            validationError = nil
        }

        // Update unique features when pattern is valid
        if isPatternValid {
            updateUniqueFeatures(pattern: patternToValidate)
        } else {
            complexityScore = nil
            patternExplanation = nil
            backtrackingAnalysis = nil
        }
    }

    // MARK: - Unique Features
    private func updateUniqueFeatures(pattern: String) {
        // Complexity analysis
        complexityScore = complexityAnalyzer.calculateComplexity(pattern)

        // Pattern explanation
        patternExplanation = explanationGenerator.explain(pattern)

        // Backtracking analysis (if test text is available)
        if !testText.isEmpty {
            backtrackingAnalysis = backtrackingVisualizer.analyzeBacktracking(pattern: pattern, text: testText)
        }
    }

    // MARK: - Testing
    // MARK: - Highlighting
    private func updateHighlighting() {
        guard !testText.isEmpty else {
            highlightedText = nil
            return
        }

        highlightedText = matchHighlighter.highlight(
            text: testText,
            matches: matches,
            highlightMatches: true,
            highlightCaptureGroups: true
        )
    }

    // MARK: - Testing
    func testPattern() {
        // Validate inputs
        guard !pattern.isEmpty else {
            matches = []
            highlightedText = nil
            validationError = ErrorFormatter.format(RegexError.emptyPattern)
            return
        }

        guard !testText.isEmpty else {
            matches = []
            highlightedText = nil
            validationError = ErrorFormatter.format(RegexError.emptyTestText)
            // Still update unique features even without test text
            if isPatternValid {
                updateUniqueFeatures(pattern: pattern)
            }
            return
        }

        guard isPatternValid else {
            matches = []
            highlightedText = nil
            // Error message already set during validation
            return
        }

        do {
            let options = regexOptions.toNSRegularExpressionOptions()
            matches = try regexEngine.match(pattern: pattern, in: testText, options: options)

            // Clear any previous errors on successful match
            validationError = nil

            // Update highlighting
            updateHighlighting()

            // Update backtracking analysis with test text
            updateUniqueFeatures(pattern: pattern)
        } catch {
            // Format error for better user experience
            if let nsError = error as NSError? {
                validationError = ErrorFormatter.format(RegexError.fromNSError(nsError, pattern: pattern))
            } else {
                validationError = ErrorFormatter.format(RegexError.matchError(error.localizedDescription))
            }
            matches = []
            highlightedText = nil
            Logger.error("Pattern matching failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Actions
    func clearPattern() {
        pattern = ""
        matches = []
        validationError = nil
    }

    func clearTestText() {
        testText = ""
        matches = []
    }

    func clearAll() {
        clearPattern()
        clearTestText()
    }
}

// MARK: - Regex Options
struct RegexOptions {
    var caseInsensitive: Bool = false
    var allowCommentsAndWhitespace: Bool = false
    var ignoreMetacharacters: Bool = false
    var dotMatchesLineSeparators: Bool = false
    var anchorsMatchLines: Bool = false
    var useUnixLineSeparators: Bool = false
    var useUnicodeWordBoundaries: Bool = false

    func toNSRegularExpressionOptions() -> NSRegularExpression.Options {
        var options: NSRegularExpression.Options = []

        if caseInsensitive {
            options.insert(.caseInsensitive)
        }
        if allowCommentsAndWhitespace {
            options.insert(.allowCommentsAndWhitespace)
        }
        if ignoreMetacharacters {
            options.insert(.ignoreMetacharacters)
        }
        if dotMatchesLineSeparators {
            options.insert(.dotMatchesLineSeparators)
        }
        if anchorsMatchLines {
            options.insert(.anchorsMatchLines)
        }
        if useUnixLineSeparators {
            options.insert(.useUnixLineSeparators)
        }
        if useUnicodeWordBoundaries {
            options.insert(.useUnicodeWordBoundaries)
        }

        return options
    }
}


