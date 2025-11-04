//
//  PersistenceController.swift
//  PatternSorcerer
//
//  Created on 2025-11-04
//

import Foundation
import SwiftData

/// Manages SwiftData persistence
@MainActor
class PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init() {
        let schema = Schema([
            Pattern.self,
            TestCase.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
