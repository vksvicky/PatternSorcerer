//
//  CodeExportService.swift
//  PatternSorcerer
//
//  Service for exporting regex patterns to code in various languages
//
//  Created on 2025-11-04
//

import AppKit
import Foundation

/// Service for exporting regex patterns to code
class CodeExportService: CodeExportServiceProtocol {

    // MARK: - CodeExportServiceProtocol

    func exportCode(
        pattern: String,
        testText: String?,
        language: CodeLanguage,
        options: CodeExportOptions
    ) throws -> String {
        // Validate pattern first
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        _ = regex // Validate by creating regex

        // Generate code based on language
        switch language {
        case .swift:
            return generateSwiftCode(pattern: pattern, testText: testText, options: options)
        case .python:
            return generatePythonCode(pattern: pattern, testText: testText, options: options)
        case .javascript:
            return generateJavaScriptCode(pattern: pattern, testText: testText, options: options)
        case .java:
            return generateJavaCode(pattern: pattern, testText: testText, options: options)
        case .go:
            return generateGoCode(pattern: pattern, testText: testText, options: options)
        case .rust:
            return generateRustCode(pattern: pattern, testText: testText, options: options)
        case .csharp:
            return generateCSharpCode(pattern: pattern, testText: testText, options: options)
        case .ruby:
            return generateRubyCode(pattern: pattern, testText: testText, options: options)
        case .php:
            return generatePHPCode(pattern: pattern, testText: testText, options: options)
        }
    }

    func copyToClipboard(_ code: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(code, forType: .string)
    }

    func saveToFile(_ code: String, url: URL) throws {
        try code.write(to: url, atomically: true, encoding: .utf8)
    }

    // MARK: - Code Generation

    private func generateSwiftCode(pattern: String, testText: String?, options: CodeExportOptions) -> String {
        let escapedPattern = escapePatternForSwift(pattern)
        let optionsString = generateSwiftOptions(options)
        let testTextCode = testText.map { "let text = \(escapeString($0))" } ?? "let text = \"your text here\""

        return """
        import Foundation

        let pattern = #"\(escapedPattern)"#
        let regex = try? NSRegularExpression(pattern: pattern, options: \(optionsString))
        \(testTextCode)
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = regex?.matches(in: text, options: [], range: range)

        for match in matches ?? [] {
            let matchRange = Range(match.range, in: text)
            if let matchRange = matchRange {
                print(String(text[matchRange]))
            }
        }
        """
    }

    private func generatePythonCode(pattern: String, testText: String?, options: CodeExportOptions) -> String {
        let escapedPattern = escapePatternForPython(pattern)
        let flags = generatePythonFlags(options)
        let testTextCode = testText.map { "text = \(escapeString($0))" } ?? "text = \"your text here\""

        return """
        import re

        pattern = r"\(escapedPattern)"
        \(testTextCode)
        matches = re.findall(pattern, text\(flags.isEmpty ? "" : ", flags=\(flags))")

        for match in matches:
            print(match)
        """
    }

    private func generateJavaScriptCode(pattern: String, testText: String?, options: CodeExportOptions) -> String {
        let escapedPattern = escapePatternForJavaScript(pattern)
        let flags = generateJavaScriptFlags(options)
        let testTextCode = testText.map { "const text = \(escapeString($0))" } ?? "const text = \"your text here\""

        return """
        const pattern = /\(escapedPattern)/\(flags)
        \(testTextCode)
        const matches = text.match(pattern)

        if (matches) {
            matches.forEach(match => console.log(match))
        }
        """
    }

    private func generateJavaCode(pattern: String, testText: String?, options: CodeExportOptions) -> String {
        let escapedPattern = escapePatternForJava(pattern)
        let flags = generateJavaFlags(options)
        let testTextCode = testText.map { "String text = \(escapeString($0))" } ?? "String text = \"your text here\""

        return """
        import java.util.regex.Pattern;
        import java.util.regex.Matcher;

        String pattern = "\(escapedPattern)";
        Pattern regex = Pattern.compile(pattern\(flags.isEmpty ? "" : ", \(flags))");
        \(testTextCode)
        Matcher matcher = regex.matcher(text);

        while (matcher.find()) {
            System.out.println(matcher.group());
        }
        """
    }

    private func generateGoCode(pattern: String, testText: String?, options: CodeExportOptions) -> String {
        let escapedPattern = escapePatternForGo(pattern)
        let testTextCode = testText.map { "text := \(escapeString($0))" } ?? "text := \"your text here\""

        return """
        package main

        import (
            "fmt"
            "regexp"
        )

        func main() {
            pattern := `\(escapedPattern)`
            regex := regexp.MustCompile(pattern)
            \(testTextCode)
            matches := regex.FindAllString(text, -1)

            for _, match := range matches {
                fmt.Println(match)
            }
        }
        """
    }

    private func generateRustCode(pattern: String, testText: String?, options: CodeExportOptions) -> String {
        let escapedPattern = escapePatternForRust(pattern)
        let testTextCode = testText.map { "let text = \(escapeString($0))" } ?? "let text = \"your text here\""

        return """
        use regex::Regex;

        fn main() {
            let pattern = r"\(escapedPattern)";
            let regex = Regex::new(pattern).unwrap();
            \(testTextCode)

            for mat in regex.find_iter(text) {
                println!("{}", mat.as_str());
            }
        }
        """
    }

    private func generateCSharpCode(pattern: String, testText: String?, options: CodeExportOptions) -> String {
        let escapedPattern = escapePatternForCSharp(pattern)
        let optionsString = generateCSharpOptions(options)
        let testTextCode = testText.map { "string text = \(escapeString($0))" } ?? "string text = \"your text here\""

        return """
        using System;
        using System.Text.RegularExpressions;

        class Program {
            static void Main() {
                string pattern = @\"\(escapedPattern)\";
                Regex regex = new Regex(pattern\(optionsString.isEmpty ? "" : ", \(optionsString))");
                \(testTextCode)
                MatchCollection matches = regex.Matches(text);

                foreach (Match match in matches) {
                    Console.WriteLine(match.Value);
                }
            }
        }
        """
    }

    private func generateRubyCode(pattern: String, testText: String?, options: CodeExportOptions) -> String {
        let escapedPattern = escapePatternForRuby(pattern)
        let flags = generateRubyFlags(options)
        let testTextCode = testText.map { "text = \(escapeString($0))" } ?? "text = \"your text here\""

        return """
        pattern = /\(escapedPattern)/\(flags)
        \(testTextCode)
        matches = text.scan(pattern)

        matches.each do |match|
            puts match
        end
        """
    }

    private func generatePHPCode(pattern: String, testText: String?, options: CodeExportOptions) -> String {
        let escapedPattern = escapePatternForPHP(pattern)
        let flags = generatePHPFlags(options)
        let testTextCode = testText.map { "$text = \(escapeString($0))" } ?? "$text = \"your text here\""

        return """
        <?php
        $pattern = "/\(escapedPattern)/\(flags)";
        \(testTextCode)
        preg_match_all($pattern, $text, $matches);

        foreach ($matches[0] as $match) {
            echo $match . "\\n";
        }
        ?>
        """
    }

    // MARK: - Helper Methods

    private func escapePatternForSwift(_ pattern: String) -> String {
        // Swift raw strings handle most escaping, but we need to escape " if not using raw string
        return pattern.replacingOccurrences(of: "\"", with: "\\\"")
    }

    private func escapePatternForPython(_ pattern: String) -> String {
        // Python raw strings handle most escaping
        return pattern.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }

    private func escapePatternForJavaScript(_ pattern: String) -> String {
        // JavaScript regex literals need escaping
        return pattern.replacingOccurrences(of: "/", with: "\\/")
            .replacingOccurrences(of: "\\", with: "\\\\")
    }

    private func escapePatternForJava(_ pattern: String) -> String {
        // Java strings need escaping
        return pattern.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }

    private func escapePatternForGo(_ pattern: String) -> String {
        // Go raw strings handle most escaping
        return pattern.replacingOccurrences(of: "`", with: "\\`")
    }

    private func escapePatternForRust(_ pattern: String) -> String {
        // Rust raw strings handle most escaping
        return pattern.replacingOccurrences(of: "\"", with: "\\\"")
    }

    private func escapePatternForCSharp(_ pattern: String) -> String {
        // C# verbatim strings handle most escaping
        return pattern.replacingOccurrences(of: "\"", with: "\"\"")
    }

    private func escapePatternForRuby(_ pattern: String) -> String {
        // Ruby regex literals need minimal escaping
        return pattern.replacingOccurrences(of: "/", with: "\\/")
    }

    private func escapePatternForPHP(_ pattern: String) -> String {
        // PHP regex needs escaping
        return pattern.replacingOccurrences(of: "/", with: "\\/")
            .replacingOccurrences(of: "\\", with: "\\\\")
    }

    private func escapeString(_ string: String) -> String {
        return "\"" + string.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\t", with: "\\t") + "\""
    }

    private func generateSwiftOptions(_ options: CodeExportOptions) -> String {
        var optionStrings: [String] = []
        if options.caseInsensitive { optionStrings.append(".caseInsensitive") }
        if options.multiline { optionStrings.append(".anchorsMatchLines") }
        if options.dotMatchesNewline { optionStrings.append(".dotMatchesLineSeparators") }
        if options.allowComments { optionStrings.append(".allowCommentsAndWhitespace") }
        if options.ignoreMetacharacters { optionStrings.append(".ignoreMetacharacters") }

        return optionStrings.isEmpty ? "[]" : "[\(optionStrings.joined(separator: ", "))]"
    }

    private func generatePythonFlags(_ options: CodeExportOptions) -> String {
        var flags: [String] = []
        if options.caseInsensitive { flags.append("re.IGNORECASE") }
        if options.multiline { flags.append("re.MULTILINE") }
        if options.dotMatchesNewline { flags.append("re.DOTALL") }

        return flags.isEmpty ? "" : flags.joined(separator: " | ")
    }

    private func generateJavaScriptFlags(_ options: CodeExportOptions) -> String {
        var flags: [String] = []
        if options.caseInsensitive { flags.append("i") }
        if options.multiline { flags.append("m") }
        if options.dotMatchesNewline { flags.append("s") }

        return flags.joined()
    }

    private func generateJavaFlags(_ options: CodeExportOptions) -> String {
        var flags: [String] = []
        if options.caseInsensitive { flags.append("Pattern.CASE_INSENSITIVE") }
        if options.multiline { flags.append("Pattern.MULTILINE") }
        if options.dotMatchesNewline { flags.append("Pattern.DOTALL") }

        return flags.joined(separator: " | ")
    }

    private func generateCSharpOptions(_ options: CodeExportOptions) -> String {
        var optionStrings: [String] = []
        if options.caseInsensitive { optionStrings.append("RegexOptions.IgnoreCase") }
        if options.multiline { optionStrings.append("RegexOptions.Multiline") }
        if options.dotMatchesNewline { optionStrings.append("RegexOptions.Singleline") }

        return optionStrings.joined(separator: " | ")
    }

    private func generateRubyFlags(_ options: CodeExportOptions) -> String {
        var flags: [String] = []
        if options.caseInsensitive { flags.append("i") }
        if options.multiline { flags.append("m") }

        return flags.joined()
    }

    private func generatePHPFlags(_ options: CodeExportOptions) -> String {
        var flags: [String] = []
        if options.caseInsensitive { flags.append("i") }
        if options.multiline { flags.append("m") }
        if options.dotMatchesNewline { flags.append("s") }

        return flags.joined()
    }
}
