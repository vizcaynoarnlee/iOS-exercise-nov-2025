//
//  UserRequestEndpoint.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import Foundation

enum UserRequestEndpoint: EndpointProtocol {
    case getUsers
    case getVisitors
    
    var path: String {
        switch self {
        case .getUsers:
            return "downapp/sample/main/sample.json"
            
        case .getVisitors:
            return "downapp/visitors"
        }
    }
    
    var method: EndpointMethod {
        .GET
    }
}
