//
//  APIClientError.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import Foundation

// Used to display localized error messages
enum APIClientError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case invalidJsonDecoding
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
            
        case .invalidResponse:
            return "Invalid URL Response"
            
        case .invalidJsonDecoding:
            return "Invalid JSON Decoding"
        }
    }
}
