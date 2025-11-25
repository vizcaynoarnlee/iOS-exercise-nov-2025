//
//  MockAPIClient.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

@testable import DownCopy
import Foundation

final class MockAPIClient: APIClientProtocol {
    var getArrayCalled = false

    var baseURLString: String = "https:mockurl.com"

    var dataArray: (any Codable)?

    func getArray<T>(endpoint: any EndpointProtocol) async throws -> [T] where T: Codable {
        getArrayCalled = true
        return dataArray as? [T] ?? []
    }

    func reset() {
        getArrayCalled = false
        dataArray = nil
    }
}
