//
//  LocalizedString.swift
//  PatternSorcerer
//
//  Helper for localized strings
//
//  Created on $(date)
//

import Foundation

/// Helper for accessing localized strings
enum LocalizedString {
    
    // MARK: - App
    static var appName: String {
        NSLocalizedString("app.name", comment: "App name")
    }
    
    static func appVersion(_ version: String) -> String {
        String(format: NSLocalizedString("app.version", comment: "App version"), version)
    }
    
    static func appCopyright(_ year: String) -> String {
        String(format: NSLocalizedString("app.copyright", comment: "App copyright"), year)
    }
    
    // MARK: - Menu
    static var menuFile: String {
        NSLocalizedString("menu.file", comment: "File menu")
    }
    
    static var menuNewPattern: String {
        NSLocalizedString("menu.new_pattern", comment: "New Pattern")
    }
    
    static var menuOpenPattern: String {
        NSLocalizedString("menu.open_pattern", comment: "Open Pattern Library")
    }
    
    static var menuEdit: String {
        NSLocalizedString("menu.edit", comment: "Edit menu")
    }
    
    static var menuFind: String {
        NSLocalizedString("menu.find", comment: "Find")
    }
    
    static var menuFindReplace: String {
        NSLocalizedString("menu.find_replace", comment: "Find and Replace")
    }
    
    static var menuPattern: String {
        NSLocalizedString("menu.pattern", comment: "Pattern menu")
    }
    
    static var menuTools: String {
        NSLocalizedString("menu.tools", comment: "Tools menu")
    }
    
    static var menuTestRegex: String {
        NSLocalizedString("menu.test_regex", comment: "Test Regex")
    }
    
    static var menuExportCode: String {
        NSLocalizedString("menu.export_code", comment: "Export Code")
    }
    
    static var menuView: String {
        NSLocalizedString("menu.view", comment: "View menu")
    }
    
    static var menuToggleSidebar: String {
        NSLocalizedString("menu.toggle_sidebar", comment: "Toggle Sidebar")
    }
    
    static var menuWindow: String {
        NSLocalizedString("menu.window", comment: "Window menu")
    }
    
    static var menuMinimize: String {
        NSLocalizedString("menu.minimize", comment: "Minimize")
    }
    
    static var menuHelp: String {
        NSLocalizedString("menu.help", comment: "Help menu")
    }
    
    static var menuHelpPatternSorcerer: String {
        NSLocalizedString("menu.help_patternsorcerer", comment: "PatternSorcerer Help")
    }
    
    static var menuLearnRegex: String {
        NSLocalizedString("menu.learn_regex", comment: "Learn Regex")
    }
    
    static var menuAbout: String {
        NSLocalizedString("menu.about", comment: "About PatternSorcerer")
    }
    
    // MARK: - Regex Tester
    static var regexTesterTitle: String {
        NSLocalizedString("regex_tester.title", comment: "Regex Tester")
    }
    
    static var regexTesterPattern: String {
        NSLocalizedString("regex_tester.pattern", comment: "Pattern")
    }
    
    static var regexTesterTestText: String {
        NSLocalizedString("regex_tester.test_text", comment: "Test Text")
    }
    
    static var regexTesterResults: String {
        NSLocalizedString("regex_tester.results", comment: "Results")
    }
    
    static var regexTesterMatches: String {
        NSLocalizedString("regex_tester.matches", comment: "Matches")
    }
    
    static var regexTesterMatch: String {
        NSLocalizedString("regex_tester.match", comment: "Match")
    }
    
    static var regexTesterNoMatches: String {
        NSLocalizedString("regex_tester.no_matches", comment: "No matches found")
    }
    
    static var regexTesterEnterPattern: String {
        NSLocalizedString("regex_tester.enter_pattern", comment: "Enter regex pattern")
    }
    
    static var regexTesterValid: String {
        NSLocalizedString("regex_tester.valid", comment: "Valid")
    }
    
    static var regexTesterInvalid: String {
        NSLocalizedString("regex_tester.invalid", comment: "Invalid")
    }
    
    static var regexTesterClear: String {
        NSLocalizedString("regex_tester.clear", comment: "Clear")
    }
    
    static func regexTesterPosition(_ position: Int) -> String {
        String(format: NSLocalizedString("regex_tester.position", comment: "Position"), position)
    }
    
    static var regexTesterCaptureGroups: String {
        NSLocalizedString("regex_tester.capture_groups", comment: "Capture Groups")
    }
    
    static func regexTesterGroup(_ index: Int) -> String {
        String(format: NSLocalizedString("regex_tester.group", comment: "Group"), index)
    }
    
    // MARK: - Tabs
    static var tabsMatches: String {
        NSLocalizedString("tabs.matches", comment: "Matches")
    }
    
    static var tabsExplanation: String {
        NSLocalizedString("tabs.explanation", comment: "Explanation")
    }
    
    static var tabsComplexity: String {
        NSLocalizedString("tabs.complexity", comment: "Complexity")
    }
    
    static var tabsBacktracking: String {
        NSLocalizedString("tabs.backtracking", comment: "Backtracking")
    }
    
    // MARK: - Explanation
    static var explanationSummary: String {
        NSLocalizedString("explanation.summary", comment: "Summary")
    }
    
    static var explanationBreakdown: String {
        NSLocalizedString("explanation.breakdown", comment: "Pattern Breakdown")
    }
    
    static var explanationEnterPattern: String {
        NSLocalizedString("explanation.enter_pattern", comment: "Enter a valid pattern to see explanation")
    }
    
    // MARK: - Complexity
    static var complexityScore: String {
        NSLocalizedString("complexity.score", comment: "Complexity Score")
    }
    
    static var complexityFactors: String {
        NSLocalizedString("complexity.factors", comment: "Complexity Factors")
    }
    
    static var complexitySuggestions: String {
        NSLocalizedString("complexity.suggestions", comment: "Optimization Suggestions")
    }
    
    static var complexityEnterPattern: String {
        NSLocalizedString("complexity.enter_pattern", comment: "Enter a valid pattern to analyze complexity")
    }
    
    // MARK: - Backtracking
    static var backtrackingRisk: String {
        NSLocalizedString("backtracking.risk", comment: "Backtracking Risk")
    }
    
    static var backtrackingWarnings: String {
        NSLocalizedString("backtracking.warnings", comment: "Warnings")
    }
    
    static var backtrackingSuggestions: String {
        NSLocalizedString("backtracking.suggestions", comment: "Suggestions")
    }
    
    static var backtrackingEnterPatternText: String {
        NSLocalizedString("backtracking.enter_pattern_text", comment: "Enter pattern and test text to analyze backtracking")
    }
    
    // MARK: - Options
    static var optionsTitle: String {
        NSLocalizedString("options.title", comment: "Options")
    }
    
    static var optionsCaseInsensitive: String {
        NSLocalizedString("options.case_insensitive", comment: "Case Insensitive")
    }
    
    static var optionsAllowComments: String {
        NSLocalizedString("options.allow_comments", comment: "Allow Comments")
    }
    
    static var optionsIgnoreMetacharacters: String {
        NSLocalizedString("options.ignore_metacharacters", comment: "Ignore Metacharacters")
    }
    
    static var optionsDotMatchesLines: String {
        NSLocalizedString("options.dot_matches_lines", comment: "Dot Matches Line Separators")
    }
    
    // MARK: - Settings
    static var settingsTitle: String {
        NSLocalizedString("settings.title", comment: "Settings")
    }
    
    static var settingsGeneral: String {
        NSLocalizedString("settings.general", comment: "General")
    }
    
    static var settingsAppearance: String {
        NSLocalizedString("settings.appearance", comment: "Appearance")
    }
    
    static var settingsEditor: String {
        NSLocalizedString("settings.editor", comment: "Editor")
    }
    
    static var settingsAdvanced: String {
        NSLocalizedString("settings.advanced", comment: "Advanced")
    }
    
    // MARK: - Sidebar
    static var sidebarTitle: String {
        NSLocalizedString("sidebar.title", comment: "PatternSorcerer")
    }
    
    static var sidebarRegexTester: String {
        NSLocalizedString("sidebar.regex_tester", comment: "Regex Tester")
    }
    
    static var sidebarPatternBuilder: String {
        NSLocalizedString("sidebar.pattern_builder", comment: "Pattern Builder")
    }
    
    static var sidebarPatternLibrary: String {
        NSLocalizedString("sidebar.pattern_library", comment: "Pattern Library")
    }
    
    static var sidebarCodeExport: String {
        NSLocalizedString("sidebar.code_export", comment: "Code Export")
    }
    
    static var sidebarPerformance: String {
        NSLocalizedString("sidebar.performance", comment: "Performance")
    }
    
    static var sidebarTutorials: String {
        NSLocalizedString("sidebar.tutorials", comment: "Tutorials")
    }
}

