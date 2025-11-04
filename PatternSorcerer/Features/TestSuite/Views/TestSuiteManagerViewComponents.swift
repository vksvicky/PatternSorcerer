//
//  TestSuiteManagerViewComponents.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import SwiftUI

// MARK: - Supporting Views

struct TestCaseRowView: View {
    let testCase: TestCase

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(testCase.name)
                .font(.headline)
            Text(testCase.testText)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 4)
    }
}

struct TestResultRowView: View {
    let result: TestCaseResult

    var body: some View {
        HStack {
            Image(systemName: result.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(result.passed ? .green : .red)

            VStack(alignment: .leading, spacing: 4) {
                Text(result.testCase.name)
                    .font(.headline)
                Text(
                    "\(LocalizedString.testSuiteExpected): \(result.expectedMatches) | "
                    + "\(LocalizedString.testSuiteActual): \(result.actualMatches)"
                )
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Sheet Views

struct AddTestCaseSheet: View {
    @Binding var isPresented: Bool
    @Binding var newTestCaseName: String
    @Binding var newTestCaseText: String
    @Binding var newTestCaseExpectedMatches: Int
    @Binding var newTestCaseShouldMatch: Bool
    let onAdd: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField(LocalizedString.testSuiteName, text: $newTestCaseName)
                TextField(LocalizedString.testSuiteTestText, text: $newTestCaseText, axis: .vertical)
                    .lineLimit(3...10)
                Stepper(
                    "\(LocalizedString.testSuiteExpectedMatches): \(newTestCaseExpectedMatches)",
                    value: $newTestCaseExpectedMatches,
                    in: 0...100
                )
                Toggle(LocalizedString.testSuiteShouldMatch, isOn: $newTestCaseShouldMatch)
            }
            .padding()
            .frame(width: 500, height: 400)
            .navigationTitle(LocalizedString.testSuiteAddTestCase)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.commonClose) {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizedString.testSuiteAdd) {
                        onAdd()
                    }
                    .disabled(
                        newTestCaseName.isEmpty || newTestCaseText.isEmpty
                    )
                }
            }
        }
    }
}

struct TemplatesSheet: View {
    @Binding var isPresented: Bool
    let templates: [TestCaseTemplate]
    let onSelectTemplate: (TestCaseTemplate) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(templates) { template in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(template.name)
                            .font(.headline)
                        if let description = template.description {
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Text(template.testText)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelectTemplate(template)
                        isPresented = false
                    }
                }
            }
            .frame(width: 500, height: 400)
            .navigationTitle(LocalizedString.testSuiteTemplates)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.commonClose) {
                        isPresented = false
                    }
                }
            }
        }
    }
}
