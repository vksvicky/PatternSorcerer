//
//  ProfessionalToolsView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import SwiftUI

struct ProfessionalToolsView: View {
    @State private var selectedTool: Tool = .replace

    enum Tool: String, CaseIterable {
        case replace
        case split
        case extract

        var localizedTitle: String {
            switch self {
            case .replace: return LocalizedString.replaceToolTitle
            case .split: return LocalizedString.splitToolTitle
            case .extract: return LocalizedString.extractToolTitle
            }
        }

        var systemImage: String {
            switch self {
            case .replace: return "arrow.2.squarepath"
            case .split: return "scissors"
            case .extract: return "arrow.down.circle"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Tool selector
            Picker("Tool", selection: $selectedTool) {
                ForEach(Tool.allCases, id: \.self) { tool in
                    Label(tool.localizedTitle, systemImage: tool.systemImage).tag(tool)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Divider()

            // Tool content
            Group {
                switch selectedTool {
                case .replace:
                    ReplaceToolView()
                case .split:
                    SplitToolView()
                case .extract:
                    ExtractToolView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
