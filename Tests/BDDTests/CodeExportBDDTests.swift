//
//  CodeExportBDDTests.swift
//  PatternSorcererTests
//
//  BDD-style tests for Code Export feature
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class CodeExportBDDTests: XCTestCase {
    var sut: CodeExportViewModel!
    var mockCodeExportService: MockCodeExportService!

    override func setUp() {
        super.setUp()
        mockCodeExportService = MockCodeExportService()
        sut = CodeExportViewModel(codeExportService: mockCodeExportService)
    }

    override func tearDown() {
        sut = nil
        mockCodeExportService = nil
        super.tearDown()
    }

    // MARK: - Feature: Export Pattern to Swift

    func testFeature_ExportPattern_Swift_GeneratesSwiftCode() {
        // Given: a regex pattern and Swift language selected
        let pattern = "\\d+"
        sut.pattern = pattern
        sut.selectedLanguage = .swift
        mockCodeExportService.exportResult = """
        import Foundation

        let pattern = #"\\d+"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let text = "123"
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = regex?.matches(in: text, options: [], range: range)
        """

        // When: the user exports the pattern
        sut.exportCode()

        // Then: Swift code should be generated
        XCTAssertFalse(sut.exportedCode.isEmpty, "Exported code should not be empty")
        XCTAssertTrue(sut.exportedCode.contains("NSRegularExpression"), "Should contain NSRegularExpression")
        XCTAssertTrue(sut.exportedCode.contains("pattern"), "Should contain pattern")
        XCTAssertNil(sut.exportError, "Should not have export error")
    }

    // MARK: - Feature: Export Pattern to Python

    func testFeature_ExportPattern_Python_GeneratesPythonCode() {
        // Given: a regex pattern and Python language selected
        let pattern = "\\d+"
        sut.pattern = pattern
        sut.selectedLanguage = .python
        mockCodeExportService.exportResult = """
        import re

        pattern = r"\\d+"
        text = "123"
        matches = re.findall(pattern, text)
        """

        // When: the user exports the pattern
        sut.exportCode()

        // Then: Python code should be generated
        XCTAssertFalse(sut.exportedCode.isEmpty, "Exported code should not be empty")
        XCTAssertTrue(sut.exportedCode.contains("import re"), "Should contain import re")
        XCTAssertTrue(sut.exportedCode.contains("re.findall"), "Should contain re.findall")
        XCTAssertNil(sut.exportError, "Should not have export error")
    }

    // MARK: - Feature: Export Pattern to JavaScript

    func testFeature_ExportPattern_JavaScript_GeneratesJavaScriptCode() {
        // Given: a regex pattern and JavaScript language selected
        let pattern = "\\d+"
        sut.pattern = pattern
        sut.selectedLanguage = .javascript
        mockCodeExportService.exportResult = """
        const pattern = /\\d+/;
        const text = "123";
        const matches = text.match(pattern);
        """

        // When: the user exports the pattern
        sut.exportCode()

        // Then: JavaScript code should be generated
        XCTAssertFalse(sut.exportedCode.isEmpty, "Exported code should not be empty")
        XCTAssertTrue(sut.exportedCode.contains("const pattern"), "Should contain pattern declaration")
        XCTAssertTrue(sut.exportedCode.contains(".match"), "Should contain match method")
        XCTAssertNil(sut.exportError, "Should not have export error")
    }

    // MARK: - Feature: Export with Test Text

    func testFeature_ExportPattern_WithTestText_IncludesTestTextInCode() {
        // Given: a pattern with test text
        let pattern = "hello"
        let testText = "hello world"
        sut.pattern = pattern
        sut.testText = testText
        sut.selectedLanguage = .swift
        mockCodeExportService.exportResult = """
        let pattern = "hello"
        let text = "hello world"
        """

        // When: the user exports the pattern
        sut.exportCode()

        // Then: the exported code should include the test text
        XCTAssertTrue(sut.exportedCode.contains(testText), "Should include test text in exported code")
    }

    // MARK: - Feature: Export with Options

    func testFeature_ExportPattern_WithOptions_IncludesOptionsInCode() {
        // Given: a pattern with case-insensitive option
        let pattern = "hello"
        sut.pattern = pattern
        sut.selectedLanguage = .swift
        sut.options = CodeExportOptions(caseInsensitive: true, multiline: false, dotMatchesNewline: false)
        mockCodeExportService.exportResult = """
        let pattern = "hello"
        let options: NSRegularExpression.Options = [.caseInsensitive]
        """

        // When: the user exports the pattern
        sut.exportCode()

        // Then: the exported code should include options
        XCTAssertTrue(
            sut.exportedCode.contains("caseInsensitive") || sut.exportedCode.contains("options"),
            "Should include options in exported code"
        )
    }

    // MARK: - Feature: Export Error Handling

    func testFeature_ExportPattern_InvalidPattern_ShowsError() {
        // Given: an invalid pattern
        sut.pattern = "[invalid"
        sut.selectedLanguage = .swift
        mockCodeExportService.exportError = CodeExportError.invalidPattern("Invalid regex pattern")

        // When: the user tries to export
        sut.exportCode()

        // Then: an error should be shown
        XCTAssertNotNil(sut.exportError, "Should have export error")
        XCTAssertTrue(sut.exportedCode.isEmpty, "Should not have exported code when error occurs")
    }

    // MARK: - Feature: Copy to Clipboard

    func testFeature_CopyToClipboard_CopiesExportedCode() {
        // Given: exported code is available
        sut.pattern = "hello"
        sut.selectedLanguage = .swift
        mockCodeExportService.exportResult = "let pattern = \"hello\""
        sut.exportCode()
        XCTAssertFalse(sut.exportedCode.isEmpty, "Should have exported code")

        // When: the user copies to clipboard
        sut.copyToClipboard()

        // Then: code should be copied to clipboard
        // Note: We'll verify this through the clipboard service mock
        XCTAssertTrue(mockCodeExportService.copyToClipboardCalled, "Should call copy to clipboard")
    }

    // MARK: - Feature: Save to File

    func testFeature_SaveToFile_SavesCodeToFile() {
        // Given: exported code is available
        sut.pattern = "hello"
        sut.selectedLanguage = .swift
        mockCodeExportService.exportResult = "let pattern = \"hello\""
        sut.exportCode()
        XCTAssertFalse(sut.exportedCode.isEmpty, "Should have exported code")

        // When: the user saves to file
        let url = URL(fileURLWithPath: "/tmp/test.swift")
        sut.saveToFile(url: url)

        // Then: code should be saved to file
        XCTAssertTrue(mockCodeExportService.saveToFileCalled, "Should call save to file")
        XCTAssertEqual(mockCodeExportService.savedFileURL, url, "Should save to correct URL")
    }

    // MARK: - Feature: Language Selection

    func testFeature_SelectLanguage_UpdatesExportedCode() {
        // Given: a pattern is set
        sut.pattern = "\\d+"
        sut.selectedLanguage = .swift
        mockCodeExportService.exportResult = "Swift code"

        // When: Swift code is exported
        sut.exportCode()
        let swiftCode = sut.exportedCode

        // And: language is changed to Python
        sut.selectedLanguage = .python
        mockCodeExportService.exportResult = "Python code"

        // When: Python code is exported
        sut.exportCode()

        // Then: exported code should be different
        XCTAssertNotEqual(sut.exportedCode, swiftCode, "Should have different code for different languages")
        XCTAssertTrue(
            sut.exportedCode.contains("Python") || sut.exportedCode.contains("import re"),
            "Should contain Python-specific code"
        )
    }
}
