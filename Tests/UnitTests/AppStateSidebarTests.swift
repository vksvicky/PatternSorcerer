//
//  AppStateSidebarTests.swift
//  PatternSorcererTests
//
//  Unit tests for AppState sidebar toggle functionality
//
//  Created on 2025-11-04
//

@testable import PatternSorcerer
import XCTest

final class AppStateSidebarTests: XCTestCase {
    var sut: AppState!

    override func setUp() {
        super.setUp()
        sut = AppState()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Sidebar Toggle

    func testSidebarVisible_InitialState_IsTrue() {
        // Given & When
        // Initial state

        // Then
        XCTAssertTrue(sut.isSidebarVisible, "Sidebar should be visible by default")
    }

    func testToggleSidebar_WhenVisible_HidesSidebar() {
        // Given
        sut.isSidebarVisible = true

        // When
        sut.toggleSidebar()

        // Then
        XCTAssertFalse(sut.isSidebarVisible, "Sidebar should be hidden after toggle")
    }

    func testToggleSidebar_WhenHidden_ShowsSidebar() {
        // Given
        sut.isSidebarVisible = false

        // When
        sut.toggleSidebar()

        // Then
        XCTAssertTrue(sut.isSidebarVisible, "Sidebar should be visible after toggle")
    }

    func testToggleSidebar_MultipleTimes_TogglesCorrectly() {
        // Given
        let initialState = sut.isSidebarVisible

        // When
        sut.toggleSidebar()
        sut.toggleSidebar()
        sut.toggleSidebar()

        // Then
        XCTAssertNotEqual(sut.isSidebarVisible, initialState, "Should toggle from initial state")
    }
}
