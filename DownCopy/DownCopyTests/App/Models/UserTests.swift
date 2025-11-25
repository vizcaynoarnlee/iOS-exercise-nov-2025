//
//  UserTests.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

@testable import DownCopy
import Foundation
import Testing

// MARK: - User Tests

@Suite("UserTests")
struct UserTests {
    // MARK: - Initialization Tests

    @Test("User should initialize with all properties")
    func testUserInitialization() {
        // Given
        let userId = 1
        let name = "John Doe"
        let age = 30
        let loc = "New York"
        let aboutMe = "Software developer"
        let profilePicUrl = URL(string: "https://example.com/profile.jpg")

        // When
        let user = User(
            userId: userId,
            name: name,
            age: age,
            loc: loc,
            aboutMe: aboutMe,
            profilePicUrl: profilePicUrl
        )

        // Then
        #expect(user.userId == userId)
        #expect(user.name == name)
        #expect(user.age == age)
        #expect(user.loc == loc)
        #expect(user.aboutMe == aboutMe)
        #expect(user.profilePicUrl == profilePicUrl)
    }

    @Test("User should initialize with nil profilePicUrl")
    func testUserInitializationWithNilProfilePic() {
        // Given
        let user = Mock.singleUser

        // Then
        #expect(user.profilePicUrl == nil)
    }

    // MARK: - Identifiable Tests

    @Test("User id should return userId")
    func testUserIdProperty() {
        // Given
        let userId = 42
        let user = User(
            userId: userId,
            name: "Test User",
            age: 28,
            loc: "San Francisco",
            aboutMe: "Test description",
            profilePicUrl: nil
        )

        // Then
        #expect(user.id == userId)
    }

    // MARK: - Equatable Tests

    @Test("Users with same userId should be equal")
    func testUserEqualityWithSameUserId() {
        // Given
        let user1 = User(
            userId: 1,
            name: "John",
            age: 30,
            loc: "NYC",
            aboutMe: "About 1",
            profilePicUrl: nil
        )

        let user2 = User(
            userId: 1,
            name: "Jane",
            age: 25,
            loc: "LA",
            aboutMe: "About 2",
            profilePicUrl: URL(string: "https://example.com/pic.jpg")
        )

        // Then
        #expect(user1 == user2)
    }

    @Test("Users with different userId should not be equal")
    func testUserInequalityWithDifferentUserId() {
        // Given
        let user1 = User(
            userId: 1,
            name: "John",
            age: 30,
            loc: "NYC",
            aboutMe: "About",
            profilePicUrl: nil
        )

        let user2 = User(
            userId: 2,
            name: "John",
            age: 30,
            loc: "NYC",
            aboutMe: "About",
            profilePicUrl: nil
        )

        // Then
        #expect(user1 != user2)
    }

    // MARK: - Codable Tests

    @Test("User should encode to JSON correctly")
    func testUserEncoding() throws {
        // Given
        let user = User(
            userId: 1,
            name: "John Doe",
            age: 30,
            loc: "New York",
            aboutMe: "Software developer",
            profilePicUrl: URL(string: "https://example.com/profile.jpg")
        )

        // When
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try encoder.encode(user)
        let jsonString = String(data: jsonData, encoding: .utf8) ?? ""

        // Then
        #expect(jsonString.contains("\"user_id\":1"))
        #expect(jsonString.contains("\"name\":\"John Doe\""))
        #expect(jsonString.contains("\"age\":30"))
        #expect(jsonString.contains("\"loc\":\"New York\""))
        #expect(jsonString.contains("\"about_me\":\"Software developer\""))
        #expect(jsonString.contains("\"profile_pic_url\""))
    }

    @Test("User should decode from JSON correctly")
    func testUserDecoding() throws {
        // Given
        let jsonString = """
        {
            "user_id": 1,
            "name": "John Doe",
            "age": 30,
            "loc": "New York",
            "about_me": "Software developer",
            "profile_pic_url": "https://example.com/profile.jpg"
        }
        """
        let jsonData = Data(jsonString.utf8)

        // When
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(User.self, from: jsonData)

        // Then
        #expect(user.userId == 1)
        #expect(user.name == "John Doe")
        #expect(user.age == 30)
        #expect(user.loc == "New York")
        #expect(user.aboutMe == "Software developer")
        #expect(user.profilePicUrl?.absoluteString == "https://example.com/profile.jpg")
    }

    @Test("User should decode from JSON with nil profilePicUrl")
    func testUserDecodingWithNilProfilePic() throws {
        // Given
        let jsonString = """
        {
            "user_id": 1,
            "name": "John Doe",
            "age": 30,
            "loc": "New York",
            "about_me": "Software developer",
            "profile_pic_url": null
        }
        """
        let jsonData = Data(jsonString.utf8)

        // When
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(User.self, from: jsonData)

        // Then
        #expect(user.profilePicUrl == nil)
    }

    @Test("User should decode from JSON without profilePicUrl field")
    func testUserDecodingWithoutProfilePicField() throws {
        // Given
        let jsonString = """
        {
            "user_id": 1,
            "name": "John Doe",
            "age": 30,
            "loc": "New York",
            "about_me": "Software developer"
        }
        """
        let jsonData = Data(jsonString.utf8)

        // When
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(User.self, from: jsonData)

        // Then
        #expect(user.profilePicUrl == nil)
    }

    @Test("User should encode and decode correctly (round trip)")
    func testUserEncodingDecodingRoundTrip() throws {
        // Given
        let originalUser = User(
            userId: 1,
            name: "John Doe",
            age: 30,
            loc: "New York",
            aboutMe: "Software developer",
            profilePicUrl: URL(string: "https://example.com/profile.jpg")
        )

        // When
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try encoder.encode(originalUser)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedUser = try decoder.decode(User.self, from: jsonData)

        // Then
        #expect(decodedUser.userId == originalUser.userId)
        #expect(decodedUser.name == originalUser.name)
        #expect(decodedUser.age == originalUser.age)
        #expect(decodedUser.loc == originalUser.loc)
        #expect(decodedUser.aboutMe == originalUser.aboutMe)
        #expect(decodedUser.profilePicUrl == originalUser.profilePicUrl)
    }
}
