//
//  MockEndpoint.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

@testable import DownCopy
import Foundation

struct MockEndpoint: EndpointProtocol {
    let path: String
    let method: EndpointMethod
    let urlQueryItems: [URLQueryItem]?
    let jsonParameters: (any Encodable)?

    init(
        path: String = "test/path",
        method: EndpointMethod = .GET,
        urlQueryItems: [URLQueryItem]? = nil,
        jsonParameters: (any Encodable)? = nil
    ) {
        self.path = path
        self.method = method
        self.urlQueryItems = urlQueryItems
        self.jsonParameters = jsonParameters
    }
}
