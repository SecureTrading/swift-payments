//
//  DefaultAPIClientConfiguration.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

struct DefaultAPIClientConfiguration: APIClientConfiguration {

    // MARK: Properties

    /// - SeeAlso: APIClientConfiguration.scheme
    let scheme: Scheme

    /// - SeeAlso: APIClientConfiguration.host
    let host: String

    // MARK: Initializer

    /// Initializes an instance.
    ///
    /// - Parameters:
    ///     - scheme: The scheme subcomponent of the URL.
    ///     - host: The host subcomponent of the URL.
    init(scheme: Scheme, host: String) {
        self.scheme = scheme
        self.host = host
    }
}
