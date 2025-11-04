//
//  TestCaseDetailsView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import SwiftUI

struct TestCaseDetailsView: View {
    let testCase: TestCase
    let onDelete: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Name
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedString.testSuiteName)
                        .font(.headline)
                    Text(testCase.name)
                        .font(.body)
                }

                Divider()

                // Test Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedString.testSuiteTestText)
                        .font(.headline)
                    Text(testCase.testText)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                }

                Divider()

                // Expected Results
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedString.testSuiteExpectedResults)
                        .font(.headline)

                    HStack {
                        Text("\(LocalizedString.testSuiteExpectedMatches): \(testCase.expectedMatches)")
                        Spacer()
                        Text(
                            testCase.shouldMatch
                                ? LocalizedString.testSuiteShouldMatch
                                : LocalizedString.testSuiteShouldNotMatch
                        )
                            .foregroundColor(testCase.shouldMatch ? .green : .red)
                    }
                }

                Divider()

                // Actions
                HStack {
                    Button(LocalizedString.testSuiteDelete) {
                        onDelete()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)

                    Spacer()
                }
            }
            .padding()
        }
    }
}
