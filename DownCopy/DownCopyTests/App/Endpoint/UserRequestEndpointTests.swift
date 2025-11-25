//
//  UserRequestEndpointTests.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

@testable import DownCopy
import Foundation
import Testing

// MARK: - UserRequestEndpoint Tests

@Suite("UserRequestEndpointTests")
struct UserRequestEndpointTests {
    // MARK: - Path Tests

    @Test("getUsers should return correct path")
    func testGetUsersPath() {
        // Given
        let endpoint = UserRequestEndpoint.getUsers

        // Then
        #expect(endpoint.path == "downapp/sample/main/sample.json")
    }

    @Test("getVisitors should return correct path")
    func testGetVisitorsPath() {
        // Given
        let endpoint = UserRequestEndpoint.getVisitors

        // Then
        #expect(endpoint.path == "downapp/visitors")
    }

    // MARK: - Method Tests

    @Test("getUsers should return GET method")
    func testGetUsersMethod() {
        // Given
        let endpoint = UserRequestEndpoint.getUsers

        // Then
        #expect(endpoint.method == .GET)
    }

    @Test("getVisitors should return GET method")
    func testGetVisitorsMethod() {
        // Given
        let endpoint = UserRequestEndpoint.getVisitors

        // Then
        #expect(endpoint.method == .GET)
    }

    // MARK: - Default Protocol Implementation Tests

    @Test("getUsers should have nil urlQueryItems by default")
    func testGetUsersURLQueryItems() {
        // Given
        let endpoint = UserRequestEndpoint.getUsers

        // Then
        #expect(endpoint.urlQueryItems == nil)
    }

    @Test("getVisitors should have nil urlQueryItems by default")
    func testGetVisitorsURLQueryItems() {
        // Given
        let endpoint = UserRequestEndpoint.getVisitors

        // Then
        #expect(endpoint.urlQueryItems == nil)
    }

    @Test("getUsers should have nil jsonParamerters by default")
    func testGetUsersJSONParameters() {
        // Given
        let endpoint = UserRequestEndpoint.getUsers

        // Then
        #expect(endpoint.jsonParamerters == nil)
    }

    @Test("getVisitors should have nil jsonParamerters by default")
    func testGetVisitorsJSONParameters() {
        // Given
        let endpoint = UserRequestEndpoint.getVisitors

        // Then
        #expect(endpoint.jsonParamerters == nil)
    }
}
