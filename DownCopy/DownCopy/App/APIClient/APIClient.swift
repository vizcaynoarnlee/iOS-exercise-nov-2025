//
//  APIClient.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import Foundation

protocol APIClientProtocol {
    var baseURLString: String { get }

    // Method to use if we expect an array response
    func getArray<T>(endpoint: EndpointProtocol) async throws -> [T] where T : Codable
}

final class APIClient: APIClientProtocol {
    // Save somewhere like Config.plist rather literal string
    let baseURLString: String = "https://raw.githubusercontent.com/"
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func getArray<T>(endpoint: EndpointProtocol) async throws -> [T] where T : Codable {
        // Check if path is empty
        guard !endpoint.path.isEmpty else {
            throw APIClientError.invalidURL
        }
        
        let urlString = baseURLString.appending(endpoint.path)
        // Default url string for request
        var url = URL(string: urlString)
        
        // If method is get and we have url query items
        if endpoint.method == .GET,
           let urlQueryItems = endpoint.urlQueryItems,
           var components = URLComponents(string: urlString) {
            components.queryItems = urlQueryItems
            url = components.url
        }
        
        // Check if url is not nil and valid
        guard let url else {
            throw APIClientError.invalidURL
        }

        // Create url request
        var urlRequest = URLRequest(url: url)
        // Set http method
        urlRequest.httpMethod = endpoint.method.rawValue

        // If method is post and we have json parameters
        if endpoint.method == .POST, let jsonParamerters = endpoint.jsonParamerters {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(jsonParamerters)
        }

        let (data, response) = try await urlSession.data(for: urlRequest)
        let arrayData: [T] = try handleArrayResponse(data: data, response: response)

        return arrayData
    }

    private func handleArrayResponse<T: Codable>(data: Data, response: URLResponse) throws -> [T] {
        guard
            let response = response as? HTTPURLResponse,
            // Check https status code
            (200 ... 299).contains(response.statusCode)
        else {
            throw APIClientError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let dataArray = try decoder.decode([T].self, from: data)
            return dataArray
        } catch {
            debugPrint(error)
            // means we have an incorrect map of model
            // means api response data is incorrect
            throw APIClientError.invalidJsonDecoding
        }
    }
}
