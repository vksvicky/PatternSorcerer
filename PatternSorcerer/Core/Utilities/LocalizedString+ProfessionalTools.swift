//
//  LocalizedString+ProfessionalTools.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation

// MARK: - Professional Tools
extension LocalizedString {
    // MARK: - Professional Tools - Replace
    static var replaceToolTitle: String {
        NSLocalizedString("replace_tool.title", comment: "Replace Tool")
    }

    static var replaceToolDescription: String {
        NSLocalizedString("replace_tool.description", comment: "Find and replace text using regular expressions")
    }

    static var replaceToolPattern: String {
        NSLocalizedString("replace_tool.pattern", comment: "Pattern")
    }

    static var replaceToolPatternPlaceholder: String {
        NSLocalizedString("replace_tool.pattern_placeholder", comment: "Enter regex pattern")
    }

    static var replaceToolInputText: String {
        NSLocalizedString("replace_tool.input_text", comment: "Input Text")
    }

    static var replaceToolReplacement: String {
        NSLocalizedString("replace_tool.replacement", comment: "Replacement")
    }

    static var replaceToolReplacementPlaceholder: String {
        NSLocalizedString(
            "replace_tool.replacement_placeholder",
            comment: "Enter replacement text (use $1, $2 for capture groups)"
        )
    }

    static var replaceToolOptions: String {
        NSLocalizedString("replace_tool.options", comment: "Options")
    }

    static var replaceToolReplace: String {
        NSLocalizedString("replace_tool.replace", comment: "Replace")
    }

    static var replaceToolCopy: String {
        NSLocalizedString("replace_tool.copy", comment: "Copy Result")
    }

    static var replaceToolClear: String {
        NSLocalizedString("replace_tool.clear", comment: "Clear")
    }

    static var replaceToolOutput: String {
        NSLocalizedString("replace_tool.output", comment: "Output")
    }

    // MARK: - Professional Tools - Split
    static var splitToolTitle: String {
        NSLocalizedString("split_tool.title", comment: "Split Tool")
    }

    static var splitToolDescription: String {
        NSLocalizedString("split_tool.description", comment: "Split text using regular expression delimiters")
    }

    static var splitToolPattern: String {
        NSLocalizedString("split_tool.pattern", comment: "Pattern")
    }

    static var splitToolPatternPlaceholder: String {
        NSLocalizedString("split_tool.pattern_placeholder", comment: "Enter regex pattern (delimiter)")
    }

    static var splitToolInputText: String {
        NSLocalizedString("split_tool.input_text", comment: "Input Text")
    }

    static var splitToolOptions: String {
        NSLocalizedString("split_tool.options", comment: "Options")
    }

    static var splitToolSplit: String {
        NSLocalizedString("split_tool.split", comment: "Split")
    }

    static var splitToolCopy: String {
        NSLocalizedString("split_tool.copy", comment: "Copy Result")
    }

    static var splitToolClear: String {
        NSLocalizedString("split_tool.clear", comment: "Clear")
    }

    static var splitToolOutput: String {
        NSLocalizedString("split_tool.output", comment: "Output")
    }

    static var splitToolNoOutput: String {
        NSLocalizedString("split_tool.no_output", comment: "No output - perform split to see results")
    }

    // MARK: - Professional Tools - Extract
    static var extractToolTitle: String {
        NSLocalizedString("extract_tool.title", comment: "Extract Tool")
    }

    static var extractToolDescription: String {
        NSLocalizedString("extract_tool.description", comment: "Extract specific capture groups from matches")
    }

    static var extractToolPattern: String {
        NSLocalizedString("extract_tool.pattern", comment: "Pattern")
    }

    static var extractToolPatternPlaceholder: String {
        NSLocalizedString("extract_tool.pattern_placeholder", comment: "Enter regex pattern with capture groups")
    }

    static var extractToolInputText: String {
        NSLocalizedString("extract_tool.input_text", comment: "Input Text")
    }

    static var extractToolGroupSelection: String {
        NSLocalizedString("extract_tool.group_selection", comment: "Group Selection")
    }

    static var extractToolGroupIndex: String {
        NSLocalizedString("extract_tool.group_index", comment: "Group Index")
    }

    static var extractToolAllGroups: String {
        NSLocalizedString("extract_tool.all_groups", comment: "All Groups")
    }

    static var extractToolOptions: String {
        NSLocalizedString("extract_tool.options", comment: "Options")
    }

    static var extractToolExtract: String {
        NSLocalizedString("extract_tool.extract", comment: "Extract")
    }

    static var extractToolCopy: String {
        NSLocalizedString("extract_tool.copy", comment: "Copy Result")
    }

    static var extractToolClear: String {
        NSLocalizedString("extract_tool.clear", comment: "Clear")
    }

    static var extractToolOutput: String {
        NSLocalizedString("extract_tool.output", comment: "Output")
    }

    static var extractToolNoOutput: String {
        NSLocalizedString("extract_tool.no_output", comment: "No output - perform extract to see results")
    }
}
