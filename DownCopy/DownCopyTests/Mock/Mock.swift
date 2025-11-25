//
//  Mock.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

@testable import DownCopy
import Foundation

enum Mock {
    static let singleUser: User = {
        User(userId: 1, name: "User 1", age: 25, loc: "Location 1", aboutMe: "About 1", profilePicUrl: nil)
    }()

    static let twoUsers: [User] = [
        User(userId: 1, name: "User 1", age: 25, loc: "Location 1", aboutMe: "About 1", profilePicUrl: nil),
        User(userId: 2, name: "User 2", age: 30, loc: "Location 2", aboutMe: "About 2", profilePicUrl: nil)
    ]
    
    static let threeUsers: [User] = [
        User(userId: 1, name: "User 1", age: 25, loc: "Location 1", aboutMe: "About 1", profilePicUrl: nil),
        User(userId: 2, name: "User 2", age: 30, loc: "Location 2", aboutMe: "About 2", profilePicUrl: nil),
        User(userId: 3, name: "User 3", age: 35, loc: "Location 3", aboutMe: "About 3", profilePicUrl: nil)
    ]
}
