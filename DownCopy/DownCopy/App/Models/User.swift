//
//  User.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: Int { userId }
    
    let userId: Int
    let name: String
    let age: Int
    let loc: String
    let aboutMe: String
    let profilePicUrl: URL?

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.userId == rhs.userId
    }
}
