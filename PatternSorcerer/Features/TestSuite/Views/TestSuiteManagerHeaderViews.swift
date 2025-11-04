//
//  TestSuiteManagerHeaderViews.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import SwiftUI

struct TestSuiteManagerHeaderView: View {
    @Binding var selectedTab: TestSuiteManagerView.TestSuiteTab
    let onAddTestCase: () -> Void
    let onShowTemplates: () -> Void
    let onImport: () -> Void
    let onExport: () -> Void
    let onRunAllTests: () -> Void
    let onSave: () -> Void
    let testCasesCount: Int
    let isLoading: Bool
    let hasCurrentPattern: Bool

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(LocalizedString.testSuiteTitle)
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Picker("View", selection: $selectedTab) {
                    ForEach(TestSuiteManagerView.TestSuiteTab.allCases, id: \.self) { tab in
                        Text(tab.localizedTitle).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }

            HStack(spacing: 8) {
                Button {
                    onAddTestCase()
                } label: {
                    Label(LocalizedString.testSuiteAddTestCase, systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    onShowTemplates()
                } label: {
                    Label(LocalizedString.testSuiteTemplates, systemImage: "list.bullet.rectangle")
                }
                .buttonStyle(.bordered)

                Spacer()

                Button {
                    onImport()
                } label: {
                    Label(LocalizedString.testSuiteImport, systemImage: "square.and.arrow.down")
                }
                .buttonStyle(.bordered)

                Button {
                    onExport()
                } label: {
                    Label(LocalizedString.testSuiteExport, systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
                .disabled(testCasesCount == 0)

                Button {
                    onRunAllTests()
                } label: {
                    Label(LocalizedString.testSuiteRunAll, systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(testCasesCount == 0 || isLoading)

                Button {
                    onSave()
                } label: {
                    Label(LocalizedString.testSuiteSave, systemImage: "square.and.arrow.down.on.square")
                }
                .buttonStyle(.bordered)
                .disabled(!hasCurrentPattern)
            }
        }
        .padding()
    }
}

struct TestSuiteDetailsHeaderView: View {
    let currentPattern: Pattern?
    let testResults: [TestCaseResult]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let pattern = currentPattern {
                Text(pattern.name)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(pattern.pattern)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
            } else {
                Text(LocalizedString.testSuiteNoPattern)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

            if !testResults.isEmpty {
                HStack {
                    let passedCount = testResults.filter { $0.passed }.count
                    let totalCount = testResults.count
                    Text("\(passedCount)/\(totalCount) \(LocalizedString.testSuitePassed)")
                        .font(.subheadline)
                        .foregroundColor(passedCount == totalCount ? .green : .orange)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}
