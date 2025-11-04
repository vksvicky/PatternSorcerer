//
//  TestSuiteManagerView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct TestSuiteManagerView: View {
    @StateObject private var viewModel = TestSuiteManagerViewModel()
    @EnvironmentObject var appState: AppState
    @State private var selectedTestCase: TestCase?
    @State private var selectedResult: TestCaseResult?
    @State private var showAddTestCase = false
    @State private var showTemplates = false
    @State private var showImportDialog = false
    @State private var showExportDialog = false
    @State private var newTestCaseName = ""
    @State private var newTestCaseText = ""
    @State private var newTestCaseExpectedMatches = 1
    @State private var newTestCaseShouldMatch = true
    @State private var selectedTab: TestSuiteTab = .testCases

    enum TestSuiteTab: String, CaseIterable {
        case testCases
        case results

        var localizedTitle: String {
            switch self {
            case .testCases: return LocalizedString.testSuiteTestCases
            case .results: return LocalizedString.testSuiteResults
            }
        }
    }

    var body: some View {
        HSplitView {
            // Left side: Test Cases Management
            VStack(spacing: 0) {
                TestSuiteManagerHeaderView(
                    selectedTab: $selectedTab,
                    onAddTestCase: { showAddTestCase = true },
                    onShowTemplates: { showTemplates = true },
                    onImport: { showImportDialog = true },
                    onExport: { showExportDialog = true },
                    onRunAllTests: { viewModel.runAllTests() },
                    onSave: { viewModel.saveTestCases() },
                    testCasesCount: viewModel.testCases.count,
                    isLoading: viewModel.isLoading,
                    hasCurrentPattern: viewModel.currentPattern != nil
                )

                Divider()

                if selectedTab == .testCases {
                    testCasesListSection
                } else {
                    testResultsSection
                }
            }
            .frame(minWidth: 400)

            Divider()

            // Right side: Details and Actions
            VStack(spacing: 0) {
                TestSuiteDetailsHeaderView(
                    currentPattern: viewModel.currentPattern,
                    testResults: viewModel.testResults
                )

                Divider()

                if selectedTab == .testCases {
                    testCaseDetailsSection
                } else {
                    testResultDetailsSection
                }
            }
            .frame(minWidth: 400)
        }
        .padding()
        .onAppear {
            // Load test cases for current pattern if available
            if let pattern = appState.currentPattern {
                viewModel.loadTestCases(for: pattern)
            }
        }
        .onChange(of: appState.currentPattern) { _, newPattern in
            if let pattern = newPattern {
                viewModel.loadTestCases(for: pattern)
            }
        }
        .alert(
            "Error",
            isPresented: .constant(viewModel.error != nil),
            presenting: viewModel.error,
            actions: { _ in
                Button(LocalizedString.commonClose) {
                    viewModel.error = nil
                }
            },
            message: { error in
                Text(error)
            }
        )
        .sheet(
            isPresented: $showAddTestCase,
            content: {
                AddTestCaseSheet(
                    isPresented: $showAddTestCase,
                    newTestCaseName: $newTestCaseName,
                    newTestCaseText: $newTestCaseText,
                    newTestCaseExpectedMatches: $newTestCaseExpectedMatches,
                    newTestCaseShouldMatch: $newTestCaseShouldMatch,
                    onAdd: addTestCase
                )
            }
        )
        .sheet(
            isPresented: $showTemplates,
            content: {
                TemplatesSheet(
                    isPresented: $showTemplates,
                    templates: viewModel.availableTemplates,
                    onSelectTemplate: { template in
                        viewModel.addTestCaseFromTemplate(template)
                    }
                )
            }
        )
        .fileImporter(
            isPresented: $showImportDialog,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                importTestCases(from: url)
            }
        }
        .fileExporter(
            isPresented: $showExportDialog,
            document: TestCasesDocument(testCases: viewModel.testCases),
            contentType: .json,
            defaultFilename: "test_cases.json"
        ) { result in
            if case .success = result {
                exportTestCases(to: URL(fileURLWithPath: "/tmp"))
            }
        }
    }


    // MARK: - Test Cases List

    private var testCasesListSection: some View {
        Group {
            if viewModel.testCases.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text(LocalizedString.testSuiteNoTestCases)
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(LocalizedString.testSuiteAddFirstTestCase)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Button(LocalizedString.testSuiteAddTestCase) {
                        showAddTestCase = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $selectedTestCase) {
                    ForEach(viewModel.testCases, id: \.id) { testCase in
                        TestCaseRowView(testCase: testCase)
                            .tag(testCase)
                    }
                }
                .listStyle(.sidebar)
            }
        }
    }

    // MARK: - Test Results

    private var testResultsSection: some View {
        Group {
            if viewModel.testResults.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text(LocalizedString.testSuiteNoResults)
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(LocalizedString.testSuiteRunTestsFirst)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(selection: $selectedResult) {
                    ForEach(viewModel.testResults) { result in
                        TestResultRowView(result: result)
                            .tag(result)
                    }
                }
                .listStyle(.sidebar)
            }
        }
    }

    // MARK: - Test Case Details

    private var testCaseDetailsSection: some View {
        Group {
            if let testCase = selectedTestCase {
                TestCaseDetailsView(testCase: testCase) {
                    if let index = viewModel.testCases.firstIndex(where: { $0.id == testCase.id }) {
                        viewModel.removeTestCase(at: index)
                        selectedTestCase = nil
                    }
                }
            } else {
                VStack {
                    Text(LocalizedString.testSuiteSelectTestCase)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private var testResultDetailsSection: some View {
        Group {
            if let selectedResult = selectedResult {
                TestResultDetailsView(result: selectedResult)
            } else {
                VStack {
                    Text(LocalizedString.testSuiteSelectResult)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }


    // MARK: - Helper Methods

    private func addTestCase() {
        let testCase = TestCase(
            name: newTestCaseName,
            testText: newTestCaseText,
            expectedMatches: newTestCaseExpectedMatches,
            shouldMatch: newTestCaseShouldMatch
        )
        viewModel.addTestCase(testCase)
        resetAddTestCaseForm()
    }

    private func resetAddTestCaseForm() {
        newTestCaseName = ""
        newTestCaseText = ""
        newTestCaseExpectedMatches = 1
        newTestCaseShouldMatch = true
    }

    private func importTestCases(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            viewModel.importTestCases(from: data)
        } catch {
            viewModel.error = "Failed to import test cases: \(error.localizedDescription)"
        }
    }

    private func exportTestCases(to url: URL) {
        viewModel.exportTestCases()
        // FileExporter will handle the actual file writing
    }
}
