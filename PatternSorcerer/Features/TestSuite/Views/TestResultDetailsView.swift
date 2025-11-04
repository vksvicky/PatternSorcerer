//
//  TestResultDetailsView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import SwiftUI

struct TestResultDetailsView: View {
    let result: TestCaseResult

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Status
                HStack {
                    Image(systemName: result.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(result.passed ? .green : .red)
                    Text(
                        result.passed
                            ? LocalizedString.testSuitePassed
                            : LocalizedString.testSuiteFailed
                    )
                        .font(.headline)
                        .foregroundColor(result.passed ? .green : .red)
                }

                Divider()

                // Comparison
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedString.testSuiteComparison)
                        .font(.headline)

                    HStack {
                        VStack(alignment: .leading) {
                            Text(LocalizedString.testSuiteExpected)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(result.expectedMatches) matches")
                                .font(.body)
                                .fontWeight(.semibold)
                        }

                        Spacer()

                        Image(systemName: "arrow.right")

                        Spacer()

                        VStack(alignment: .leading) {
                            Text(LocalizedString.testSuiteActual)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(result.actualMatches) matches")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(result.passed ? .green : .red)
                        }
                    }
                }

                if !result.matches.isEmpty {
                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedString.testSuiteMatches)
                            .font(.headline)

                        ForEach(Array(result.matches.enumerated()), id: \.offset) { _, match in
                            HStack {
                                Text(match.matchedText)
                                    .font(.system(.body, design: .monospaced))
                                Spacer()
                                Text("\(match.range.location)-\(match.range.location + match.range.length)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
