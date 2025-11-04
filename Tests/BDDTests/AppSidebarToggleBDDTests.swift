//
//  AppSidebarToggleBDDTests.swift
//  PatternSorcererTests
//
//  BDD-style tests for sidebar toggle functionality
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

@MainActor
final class AppSidebarToggleBDDTests: XCTestCase {
    var sut: AppState!

    override func setUp() {
        super.setUp()
        sut = AppState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Feature: Sidebar Toggle

    func testFeature_ToggleSidebar_FromMenu_HidesOrShowsSidebar() {
        // Given: sidebar is visible
        sut.isSidebarVisible = true

        // When: user presses Cmd+Ctrl+S to toggle sidebar
        sut.toggleSidebar()

        // Then: sidebar should be hidden
        XCTAssertFalse(sut.isSidebarVisible, "Sidebar should be hidden after toggle")
    }

    func testFeature_ToggleSidebar_WhenHidden_ShowsSidebar() {
        // Given: sidebar is hidden
        sut.isSidebarVisible = false

        // When: user presses Cmd+Ctrl+S to toggle sidebar
        sut.toggleSidebar()

        // Then: sidebar should be visible
        XCTAssertTrue(sut.isSidebarVisible, "Sidebar should be visible after toggle")
    }

    func testFeature_ToggleSidebar_Twice_ReturnsToOriginalState() {
        // Given: sidebar is visible
        sut.isSidebarVisible = true

        // When: user toggles sidebar twice
        sut.toggleSidebar()
        sut.toggleSidebar()

        // Then: sidebar should be back to original state
        XCTAssertTrue(sut.isSidebarVisible, "Sidebar should return to original state")
    }
}
