//
//  APIClientTests.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

@testable import DownCopy
import Foundation
import Testing

// MARK: - APIClient Tests

@Suite("APIClientTests", .serialized)
struct APIClientTests {
    // MARK: - Setup & Teardown

    // Creates a URLSession with MockURLProtocol registered in its configuration
    private func createMockURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    // Resets the request handler
    private func resetMockURLProtocol() {
        MockURLProtocol.requestHandler = nil
    }

    // MARK: - Base URL Tests

    @Test("baseURLString")
    func testBaseURLString() {
        // Given
        let apiClient = APIClient()

        // Then
        #expect(apiClient.baseURLString == "https://raw.githubusercontent.com/")
    }

    @Test("getArray should construct correct URL from baseURLString and path")
    func testGetArrayURLConstruction() async throws {
        // Given
        let urlSession = createMockURLSession()
        let apiClient = APIClient(urlSession: urlSession)
        let testData = [MockModel(id: 1, name: "Test")]
        let jsonData = try JSONEncoder().encode(testData)

        var capturedURL: URL?
        let endpoint = MockEndpoint(path: "test/path")

        // Set handler immediately before the async call to avoid race conditions
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw URLError(.badURL)
            }
            capturedURL = url
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, jsonData)
        }
        defer { resetMockURLProtocol() }

        // When
        let _: [MockModel] = try await apiClient.getArray(endpoint: endpoint)

        // Then
        #expect(capturedURL != nil)
        if let url = capturedURL {
            #expect(url.absoluteString == "https://raw.githubusercontent.com/test/path")
        }
    }

    // MARK: - Successful GET Request Tests

    @Test("getArray success")
    func testGetArraySuccess() async throws {
        // Given
        let urlSession = createMockURLSession()
        let apiClient = APIClient(urlSession: urlSession)
        let testData = [
            MockModel(id: 1, name: "Test 1"),
            MockModel(id: 2, name: "Test 2")
        ]
        let jsonData = try JSONEncoder().encode(testData)

        let endpoint = MockEndpoint(path: "test/path")

        // Set handler immediately before the async call to avoid race conditions
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw URLError(.badURL)
            }
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, jsonData)
        }
        defer { resetMockURLProtocol() }

        // When
        let result: [MockModel] = try await apiClient.getArray(endpoint: endpoint)

        // Then
        #expect(result.count == 2)
        #expect(result[0].id == 1)
        #expect(result[0].name == "Test 1")
        #expect(result[1].id == 2)
        #expect(result[1].name == "Test 2")
    }

    @Test("getArray handle GET request with query items")
    func testGetArrayWithQueryItems() async throws {
        // Given
        let urlSession = createMockURLSession()
        let apiClient = APIClient(urlSession: urlSession)
        let testData = [MockModel(id: 1, name: "Test")]
        let jsonData = try JSONEncoder().encode(testData)

        var capturedRequest: URLRequest?
        let queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "limit", value: "10")
        ]
        let endpoint = MockEndpoint(path: "test/path", urlQueryItems: queryItems)

        // Set handler immediately before the async call to avoid race conditions
        MockURLProtocol.requestHandler = { request in
            capturedRequest = request
            guard let url = request.url else {
                throw URLError(.badURL)
            }
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, jsonData)
        }
        defer { resetMockURLProtocol() }

        // When
        let _: [MockModel] = try await apiClient.getArray(endpoint: endpoint)

        // Then
        #expect(capturedRequest != nil)
        if let request = capturedRequest,
           let url = request.url,
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let items = components.queryItems {
            #expect(items.count == 2)
            #expect(items.contains { $0.name == "page" && $0.value == "1" })
            #expect(items.contains { $0.name == "limit" && $0.value == "10" })
        }
    }

    // MARK: - POST Request Tests

    @Test("getArray handle POST request with JSON parameters")
    func testGetArrayWithPOSTRequest() async throws {
        // Given
        let urlSession = createMockURLSession()
        let apiClient = APIClient(urlSession: urlSession)
        let testData = [MockModel(id: 1, name: "Test")]
        let jsonData = try JSONEncoder().encode(testData)

        struct PostBody: Codable {
            let userId: Int
        }

        var capturedRequest: URLRequest?
        var capturedBodyData: Data?
        let postBody = PostBody(userId: 123)
        let endpoint = MockEndpoint(
            path: "test/path",
            method: .POST,
            jsonParameters: postBody
        )

        // Set handler immediately before the async call to avoid race conditions
        MockURLProtocol.requestHandler = { request in
            capturedRequest = request

            // URLSession converts httpBody to httpBodyStream, so we need to read from the stream
            if let bodyStream = request.httpBodyStream {
                var data = Data()
                var buffer = [UInt8](repeating: 0, count: 4096)
                bodyStream.open()
                defer { bodyStream.close() }
                while bodyStream.hasBytesAvailable {
                    let bytesRead = bodyStream.read(&buffer, maxLength: buffer.count)
                    if bytesRead > 0 {
                        data.append(buffer, count: bytesRead)
                    } else if bytesRead == 0 {
                        break
                    } else {
                        break
                    }
                }
                if !data.isEmpty {
                    capturedBodyData = data
                }
            } else if let body = request.httpBody {
                capturedBodyData = body
            }

            guard let url = request.url else {
                throw URLError(.badURL)
            }
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, jsonData)
        }
        defer { resetMockURLProtocol() }

        // When
        let _: [MockModel] = try await apiClient.getArray(endpoint: endpoint)

        // Then
        #expect(capturedRequest != nil)
        if let request = capturedRequest {
            #expect(request.httpMethod == "POST")
            #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
            #expect(capturedBodyData != nil, "POST request should have a body")

            if let bodyData = capturedBodyData {
                let decodedBody = try JSONDecoder().decode(PostBody.self, from: bodyData)
                #expect(decodedBody.userId == 123)
            }
        }
    }

    // MARK: - Error Handling Tests

    @Test("getArray throw invalidURL error for invalid URL")
    func testGetArrayInvalidURL() async {
        // Given
        let apiClient = APIClient()
        let endpoint = MockEndpoint(
            path: "", // path is empty throws invalid URL
            method: .GET
        )

        // When & Then
        var thrownError: APIClientError?
        do {
            let _: [MockModel] = try await apiClient.getArray(endpoint: endpoint)
        } catch let error as APIClientError {
            thrownError = error
        } catch {
            // Unexpected error type
        }

        #expect(thrownError == .invalidURL)
    }

    @Test("getArray throw invalidResponse error for non-200 status code")
    func testGetArrayInvalidResponse() async {
        // Given
        let urlSession = createMockURLSession()
        let apiClient = APIClient(urlSession: urlSession)
        let jsonData = try? JSONEncoder().encode([MockModel(id: 1, name: "Test")])
        let endpoint = MockEndpoint(path: "test/path")

        // Set handler immediately before the async call to avoid race conditions
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw URLError(.badURL)
            }
            let response = HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, jsonData ?? Data())
        }
        defer { resetMockURLProtocol() }

        // When & Then
        var thrownError: APIClientError?
        do {
            let _: [MockModel] = try await apiClient.getArray(endpoint: endpoint)
        } catch let error as APIClientError {
            thrownError = error
        } catch {
            // Unexpected error type
        }

        #expect(thrownError == .invalidResponse)
    }

    @Test("getArray throw invalidResponse error for 500 status code")
    func testGetArrayServerError() async {
        // Given
        let urlSession = createMockURLSession()
        let apiClient = APIClient(urlSession: urlSession)
        let endpoint = MockEndpoint(path: "test/path")

        // Set handler immediately before the async call to avoid race conditions
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw URLError(.badURL)
            }
            let response = HTTPURLResponse(
                url: url,
                statusCode: 500,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, Data())
        }
        defer { resetMockURLProtocol() }

        // When & Then
        var thrownError: APIClientError?
        do {
            let _: [MockModel] = try await apiClient.getArray(endpoint: endpoint)
        } catch let error as APIClientError {
            thrownError = error
        } catch {
            // Unexpected error type
        }

        #expect(thrownError == .invalidResponse)
    }

    @Test("getArray throw invalidJsonDecoding error for invalid JSON")
    func testGetArrayInvalidJSON() async {
        // Given
        let urlSession = createMockURLSession()
        let apiClient = APIClient(urlSession: urlSession)
        let invalidJSON = Data("invalid json".utf8)
        let endpoint = MockEndpoint(path: "test/path")

        // Set handler immediately before the async call to avoid race conditions
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw URLError(.badURL)
            }
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, invalidJSON)
        }
        defer { resetMockURLProtocol() }

        // When & Then
        var thrownError: APIClientError?
        do {
            let _: [MockModel] = try await apiClient.getArray(endpoint: endpoint)
        } catch let error as APIClientError {
            thrownError = error
        } catch {
            // Unexpected error type
        }

        #expect(thrownError == .invalidJsonDecoding)
    }

    @Test("getArray handle snake_case JSON decoding")
    func testGetArraySnakeCaseDecoding() async throws {
        // Given
        let urlSession = createMockURLSession()
        let apiClient = APIClient(urlSession: urlSession)

        struct SnakeCaseModel: Codable, Equatable {
            let userId: Int
            let userName: String
        }

        // JSON with snake_case keys
        let jsonString = """
        [
            {
                "user_id": 1,
                "user_name": "Test User"
            }
        ]
        """
        let jsonData = Data(jsonString.utf8)
        let endpoint = MockEndpoint(path: "test/path")

        // Set handler immediately before the async call to avoid race conditions
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw URLError(.badURL)
            }
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, jsonData)
        }
        defer { resetMockURLProtocol() }

        // When
        let result: [SnakeCaseModel] = try await apiClient.getArray(endpoint: endpoint)

        // Then
        #expect(result.count == 1)
        guard result.count == 1 else {
            return
        }
        #expect(result[0].userId == 1)
        #expect(result[0].userName == "Test User")
    }
}
