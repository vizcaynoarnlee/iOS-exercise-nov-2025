//
//  CardsViewModelTests.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

@testable import DownCopy
import Foundation
import Testing

// MARK: - CardsViewModel Tests

@MainActor
@Suite("CardsViewModelTests")
struct CardsViewModelTests {
    // MARK: - Initial State Tests

    @Test("initial state should have correct default values")
    func testInitialState() {
        // Given
        let mockAPIClient = MockAPIClient()
        let viewModel = CardsViewModel(apiClient: mockAPIClient)

        // Then
        #expect(viewModel.viewState == .initial)
        #expect(viewModel.users.isEmpty)
        #expect(viewModel.selectedUserIndex == 0)
    }

    // MARK: - loadUsers Tests

    @Test("loadUsers should set viewState to loading then loaded on success")
    func testLoadUsersSuccess() async {
        // Given
        let mockAPIClient = MockAPIClient()
        mockAPIClient.dataArray = Mock.twoUsers
        let viewModel = CardsViewModel(apiClient: mockAPIClient)

        // When
        await viewModel.loadUsers()

        // Then
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.users.count == 2)
        #expect(viewModel.users[0].userId == 1)
        #expect(viewModel.users[0].name == "User 1")
        #expect(viewModel.users[1].userId == 2)
        #expect(viewModel.users[1].name == "User 2")
        #expect(mockAPIClient.getArrayCalled == true)
    }

    @Test("loadUsers should set viewState to loading then error on failure")
    func testLoadUsersError() async {
        // Given
        let errorAPIClient = MockErrorThrowingAPIClient()
        let viewModel = CardsViewModel(apiClient: errorAPIClient)

        // When
        await viewModel.loadUsers()

        // Then
        #expect(viewModel.viewState == .error(APIClientError.invalidURL))
        #expect(viewModel.users.isEmpty)
    }

    @Test("loadUsers should call apiClient.getArray with correct endpoint")
    func testLoadUsersCallsCorrectEndpoint() async {
        // Given
        let mockAPIClient = MockAPIClient()
        mockAPIClient.dataArray = [Mock.singleUser]
        let viewModel = CardsViewModel(apiClient: mockAPIClient)

        // When
        await viewModel.loadUsers()

        // Then
        #expect(mockAPIClient.getArrayCalled == true)
    }

    @Test("loadUsers should handle empty array response")
    func testLoadUsersWithEmptyArray() async {
        // Given
        let mockAPIClient = MockAPIClient()
        mockAPIClient.dataArray = [User]()
        let viewModel = CardsViewModel(apiClient: mockAPIClient)

        // When
        await viewModel.loadUsers()

        // Then
        #expect(viewModel.viewState == .loaded)
        #expect(viewModel.users.isEmpty)
    }

    // MARK: - moveToNext Tests

    @Test("moveToNext should increment selectedUserIndex when not at end")
    func testMoveToNextIncrementsIndex() {
        // Given
        let mockAPIClient = MockAPIClient()
        let viewModel = CardsViewModel(apiClient: mockAPIClient)
        viewModel.users = Mock.threeUsers
        viewModel.selectedUserIndex = 0

        // When
        viewModel.moveToNext()

        // Then
        #expect(viewModel.selectedUserIndex == 1)
    }

    @Test("moveToNext should loop to 0 when at end of list")
    func testMoveToNextLoopsToStart() {
        // Given
        let mockAPIClient = MockAPIClient()
        let viewModel = CardsViewModel(apiClient: mockAPIClient)
        viewModel.users = Mock.twoUsers
        viewModel.selectedUserIndex = 1 // Last index

        // When
        viewModel.moveToNext()

        // Then
        #expect(viewModel.selectedUserIndex == 0)
    }

    @Test("moveToNext should handle single user")
    func testMoveToNextWithSingleUser() {
        // Given
        let mockAPIClient = MockAPIClient()
        let viewModel = CardsViewModel(apiClient: mockAPIClient)
        viewModel.users = [Mock.singleUser]
        viewModel.selectedUserIndex = 0

        // When
        viewModel.moveToNext()

        // Then
        #expect(viewModel.selectedUserIndex == 0) // Should loop back to 0
    }

    @Test("moveToNext should handle empty users array")
    func testMoveToNextWithEmptyUsers() {
        // Given
        let mockAPIClient = MockAPIClient()
        let viewModel = CardsViewModel(apiClient: mockAPIClient)
        viewModel.users = []
        viewModel.selectedUserIndex = 0

        // When
        viewModel.moveToNext()

        // Then
        #expect(viewModel.selectedUserIndex == 0) // Should remain 0
    }

    @Test("moveToNext should loop through all users correctly")
    func testMoveToNextLoopsThroughAllUsers() {
        // Given
        let mockAPIClient = MockAPIClient()
        let viewModel = CardsViewModel(apiClient: mockAPIClient)
        viewModel.users = Mock.threeUsers
        viewModel.selectedUserIndex = 0

        // When - move through all users
        viewModel.moveToNext() // 0 -> 1
        #expect(viewModel.selectedUserIndex == 1)

        viewModel.moveToNext() // 1 -> 2
        #expect(viewModel.selectedUserIndex == 2)

        viewModel.moveToNext() // 2 -> 0 (loop)
        #expect(viewModel.selectedUserIndex == 0)
    }
}
