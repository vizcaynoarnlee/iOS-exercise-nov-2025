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
            // Check for cancellation
            guard Task.isCancelled == false else { return }
            
            let users: [User] = try await apiClient.getArray(endpoint: UserRequestEndpoint.getUsers)
            
            // Check for cancellation
            guard Task.isCancelled == false else { return }
            
            self.users = users
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
            // Check for cancellation
            guard Task.isCancelled == false else { return }
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
