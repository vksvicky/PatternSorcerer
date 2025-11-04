//
//  CodeExportServiceTests.swift
//  PatternSorcererTests
//
//  Unit tests for CodeExportService
//
//  Created on 2025-11-04
//

import AppKit
@testable import PatternSorcerer
import XCTest

final class CodeExportServiceTests: XCTestCase {
    var sut: CodeExportService!

    override func setUp() {
        super.setUp()
        sut = CodeExportService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Swift Code Generation

    func testExportCode_Swift_GeneratesValidSwiftCode() throws {
        // Given
        let pattern = "\\d+"
        let testText = "123 abc"
        let options = CodeExportOptions()

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: testText,
            language: .swift,
            options: options
        )

        // Then
        XCTAssertFalse(code.isEmpty)
        XCTAssertTrue(code.contains("import Foundation"))
        XCTAssertTrue(code.contains("NSRegularExpression"))
        XCTAssertTrue(code.contains(testText))
        XCTAssertTrue(code.contains("matches"))
    }

    func testExportCode_Swift_WithOptions_IncludesOptions() throws {
        // Given
        let pattern = "hello"
        let options = CodeExportOptions(caseInsensitive: true, multiline: false, dotMatchesNewline: false)

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: nil,
            language: .swift,
            options: options
        )

        // Then
        XCTAssertTrue(code.contains("caseInsensitive") || code.contains("options"))
    }

    // MARK: - Python Code Generation

    func testExportCode_Python_GeneratesValidPythonCode() throws {
        // Given
        let pattern = "\\d+"
        let testText = "123 abc"

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: testText,
            language: .python,
            options: CodeExportOptions()
        )

        // Then
        XCTAssertFalse(code.isEmpty)
        XCTAssertTrue(code.contains("import re"))
        XCTAssertTrue(code.contains("re.findall"))
        XCTAssertTrue(code.contains(testText))
    }

    func testExportCode_Python_WithCaseInsensitive_IncludesFlag() throws {
        // Given
        let options = CodeExportOptions(caseInsensitive: true, multiline: false, dotMatchesNewline: false)

        // When
        let code = try sut.exportCode(
            pattern: "hello",
            testText: nil,
            language: .python,
            options: options
        )

        // Then
        XCTAssertTrue(code.contains("re.IGNORECASE") || code.contains("flags"))
    }

    // MARK: - JavaScript Code Generation

    func testExportCode_JavaScript_GeneratesValidJavaScriptCode() throws {
        // Given
        let pattern = "\\d+"
        let testText = "123 abc"

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: testText,
            language: .javascript,
            options: CodeExportOptions()
        )

        // Then
        XCTAssertFalse(code.isEmpty)
        XCTAssertTrue(code.contains("const pattern"))
        XCTAssertTrue(code.contains(".match"))
        XCTAssertTrue(code.contains(testText))
    }

    // MARK: - Java Code Generation

    func testExportCode_Java_GeneratesValidJavaCode() throws {
        // Given
        let pattern = "\\d+"
        let testText = "123 abc"

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: testText,
            language: .java,
            options: CodeExportOptions()
        )

        // Then
        XCTAssertFalse(code.isEmpty)
        XCTAssertTrue(code.contains("import java.util.regex"))
        XCTAssertTrue(code.contains("Pattern.compile"))
        XCTAssertTrue(code.contains("Matcher"))
        XCTAssertTrue(code.contains(testText))
    }

    // MARK: - Go Code Generation

    func testExportCode_Go_GeneratesValidGoCode() throws {
        // Given
        let pattern = "\\d+"
        let testText = "123 abc"

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: testText,
            language: .go,
            options: CodeExportOptions()
        )

        // Then
        XCTAssertFalse(code.isEmpty)
        XCTAssertTrue(code.contains("package main"))
        XCTAssertTrue(code.contains("regexp"))
        XCTAssertTrue(code.contains("FindAllString"))
        XCTAssertTrue(code.contains(testText))
    }

    // MARK: - Rust Code Generation

    func testExportCode_Rust_GeneratesValidRustCode() throws {
        // Given
        let pattern = "\\d+"
        let testText = "123 abc"

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: testText,
            language: .rust,
            options: CodeExportOptions()
        )

        // Then
        XCTAssertFalse(code.isEmpty)
        XCTAssertTrue(code.contains("use regex::Regex"))
        XCTAssertTrue(code.contains("Regex::new"))
        XCTAssertTrue(code.contains(testText))
    }

    // MARK: - C# Code Generation

    func testExportCode_CSharp_GeneratesValidCSharpCode() throws {
        // Given
        let pattern = "\\d+"
        let testText = "123 abc"

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: testText,
            language: .csharp,
            options: CodeExportOptions()
        )

        // Then
        XCTAssertFalse(code.isEmpty)
        XCTAssertTrue(code.contains("using System.Text.RegularExpressions"))
        XCTAssertTrue(code.contains("new Regex"))
        XCTAssertTrue(code.contains("MatchCollection"))
        XCTAssertTrue(code.contains(testText))
    }

    // MARK: - Ruby Code Generation

    func testExportCode_Ruby_GeneratesValidRubyCode() throws {
        // Given
        let pattern = "\\d+"
        let testText = "123 abc"

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: testText,
            language: .ruby,
            options: CodeExportOptions()
        )

        // Then
        XCTAssertFalse(code.isEmpty)
        XCTAssertTrue(code.contains(".scan"))
        XCTAssertTrue(code.contains(testText))
    }

    // MARK: - PHP Code Generation

    func testExportCode_PHP_GeneratesValidPHPCode() throws {
        // Given
        let pattern = "\\d+"
        let testText = "123 abc"

        // When
        let code = try sut.exportCode(
            pattern: pattern,
            testText: testText,
            language: .php,
            options: CodeExportOptions()
        )

        // Then
        XCTAssertFalse(code.isEmpty)
        XCTAssertTrue(code.contains("preg_match_all"))
        XCTAssertTrue(code.contains(testText))
    }

    // MARK: - Error Handling

    func testExportCode_InvalidPattern_ThrowsError() {
        // Given
        let invalidPattern = "[invalid"

        // When/Then
        XCTAssertThrowsError(try sut.exportCode(
            pattern: invalidPattern,
            testText: nil,
            language: .swift,
            options: CodeExportOptions()
        )) { error in
            // Error should be thrown during pattern validation
            XCTAssertNotNil(error)
        }
    }

    func testExportCode_EmptyPattern_ThrowsError() {
        // Given
        let emptyPattern = ""

        // When/Then
        // Note: This might be caught by ViewModel, but service should handle it
        XCTAssertThrowsError(try sut.exportCode(
            pattern: emptyPattern,
            testText: nil,
            language: .swift,
            options: CodeExportOptions()
        ))
    }

    // MARK: - Clipboard Operations

    func testCopyToClipboard_CopiesCode() {
        // Given
        let code = "let pattern = \"test\""

        // When
        sut.copyToClipboard(code)

        // Then
        // Verify clipboard contains the code
        let pasteboard = NSPasteboard.general
        let clipboardContent = pasteboard.string(forType: .string)
        XCTAssertEqual(clipboardContent, code)
    }

    // MARK: - File Operations

    func testSaveToFile_SavesCodeToFile() throws {
        // Given
        let code = "let pattern = \"test\""
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("swift")

        // When
        try sut.saveToFile(code, url: tempURL)

        // Then
        XCTAssertTrue(FileManager.default.fileExists(atPath: tempURL.path))
        let savedContent = try String(contentsOf: tempURL, encoding: .utf8)
        XCTAssertEqual(savedContent, code)

        // Cleanup
        try? FileManager.default.removeItem(at: tempURL)
    }
}
