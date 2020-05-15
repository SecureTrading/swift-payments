//
//  ApplicationKeys.swift
//  Example
//

import Foundation

/// Common interface for securely providing keys
final class ApplicationKeys {

    /// The cocoapods-keys instance
    private let keys: ExampleKeys

    /// Initializes class with given keys
    /// - Parameter keys: All Example app keys initialized with cocoapods-keys
    init(keys: ExampleKeys) {
        self.keys = keys
    }

    /// JWT secret key
    var jwtSecretKey: String {
        return keys.jWTSecret
    }
}
