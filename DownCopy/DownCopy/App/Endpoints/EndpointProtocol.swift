//
//  EndpointProtocol.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import Foundation

enum EndpointMethod: String {
    case GET
    case POST
}

// Protocol to create endpoints
protocol EndpointProtocol {
    // Path: the API path
    var path: String { get }
    // Method: http method
    var method: EndpointMethod { get }
    // Query items: url query items when method is GET
    var urlQueryItems: [URLQueryItem]? { get }
    // Parameter items: JSON parameter body when method is POST
    var jsonParamerters: (any Encodable)? { get }
}

extension EndpointProtocol {
    var urlQueryItems: [URLQueryItem]? { nil }
    var jsonParamerters: (any Encodable)? { nil }
}
