//
//  ErrorReporter.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/27/25.
//

import Foundation

protocol ErrorReporting {
    static func log(error: Error, userInfo: [String: Any]?)
    static func log(message: String, userInfo: [String: Any]?)
}

final class ErrorReporter: ErrorReporting {
    static func log(error: Error, userInfo: [String: Any]? = nil) {
        // Report error to api or third party reporting system
    }

    static func log(message: String, userInfo: [String: Any]? = nil) {
        // Report message to api or third party reporting system
    }
}
