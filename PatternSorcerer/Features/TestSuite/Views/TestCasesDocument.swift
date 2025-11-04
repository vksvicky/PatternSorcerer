//
//  TestCasesDocument.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

// MARK: - Document Types

struct TestCasesDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }

    var testCases: [TestCase]

    init(testCases: [TestCase]) {
        self.testCases = testCases
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let service = TestSuiteService()
        testCases = try service.importTestCases(from: data)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let service = TestSuiteService()
        let data = try service.exportTestCases(testCases)
        return FileWrapper(regularFileWithContents: data)
    }
}
