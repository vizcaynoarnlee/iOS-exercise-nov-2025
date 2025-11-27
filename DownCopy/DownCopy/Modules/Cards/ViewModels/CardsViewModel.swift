//
//  CardsViewModel.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import Foundation

@MainActor
protocol CardsViewModelProtocol {
    var viewState: ViewState { get }
    var users: [User] { get }
    var selectedUserIndex: Int { get set }

    func loadUsers() async
    func moveToNext()
}

@Observable
final class CardsViewModel: CardsViewModelProtocol {
    private var apiClient: APIClientProtocol

    var viewState: ViewState = .initial
    var users: [User] = []
    var selectedUserIndex: Int = 0

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func loadUsers() async {
        guard viewState != .loading else { return }
        
        viewState = .loading
        do {
            users = try await apiClient.getArray(endpoint: UserRequestEndpoint.getUsers)
            viewState = .loaded
        } catch {
            ErrorReporter.log(
                error: error,
                userInfo: [
                    "object": "CardsViewModel",
                    "issue": "UserRequestEndpoint.getUsers",
                    "timestamp": ISO8601DateFormatter().string(from: Date())
                ]
            )
            viewState = .error(error)
        }
    }

    func moveToNext() {
        // pagination should be implemented to fetch the next array users
        // end of list should display alert
        // for current purpose we loop users
        if selectedUserIndex < users.count - 1 {
            selectedUserIndex += 1
        } else {
            selectedUserIndex = 0
        }
    }
}
