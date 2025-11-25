//
//  MockErrorThrowingAPIClient.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

@testable import DownCopy
import Foundation

final class MockErrorThrowingAPIClient: APIClientProtocol {
    var baseURLString: String = "https://mockurl.com"

    func getArray<T>(endpoint: any EndpointProtocol) async throws -> [T] where T: Codable {
        throw APIClientError.invalidURL
    }
}
