//
//  RegexFlavorSelectorView.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import SwiftUI

struct RegexFlavorSelectorView: View {
    @ObservedObject var viewModel: RegexFlavorViewModel

    var body: some View {
        HStack {
            Text("Regex Flavor:")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Picker("Flavor", selection: $viewModel.selectedFlavor) {
                ForEach(viewModel.availableFlavors) { flavor in
                    HStack {
                        Image(systemName: flavor.icon)
                        Text(flavor.rawValue)
                    }
                    .tag(flavor)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 150)

            Spacer()

            if let info = viewModel.flavorInfo {
                Button {
                    // Show flavor info sheet
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.borderless)
                .help(info.description)
            }
        }
    }
}

struct FlavorInfoSheet: View {
    let flavorInfo: FlavorInfo
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Description
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.headline)
                        Text(flavorInfo.description)
                            .font(.body)
                    }

                    Divider()

                    // Features
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Supported Features")
                            .font(.headline)

                        ForEach(flavorInfo.features) { feature in
                            HStack {
                                Image(systemName: feature.supported ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(feature.supported ? .green : .red)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(feature.name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text(feature.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }

                    Divider()

                    // Common Use Cases
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Common Use Cases")
                            .font(.headline)

                        ForEach(flavorInfo.commonUseCases, id: \.self) { useCase in
                            HStack {
                                Text("•")
                                    .foregroundColor(.secondary)
                                Text(useCase)
                                    .font(.body)
                            }
                        }
                    }

                    if !flavorInfo.limitations.isEmpty {
                        Divider()

                        // Limitations
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Limitations")
                                .font(.headline)

                            ForEach(flavorInfo.limitations, id: \.self) { limitation in
                                HStack {
                                    Text("•")
                                        .foregroundColor(.orange)
                                    Text(limitation)
                                        .font(.body)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(flavorInfo.flavor.rawValue)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
        }
        .frame(width: 500, height: 600)
    }
}
