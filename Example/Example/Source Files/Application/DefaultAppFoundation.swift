//
//  DefaultAppFoundation.swift
//  Example
//

import Foundation
import SecureTradingCore

final class DefaultAppFoundation: AppFoundation {

    /// Keys for certain scheme
    public let keys = ApplicationKeys(keys: ExampleKeys())

    /// - SeeAlso: AppFoundation.apiManager
    private(set) lazy var apiManager: APIManager = {
        DefaultAPIManager(gatewayType: .eu, username: keys.merchantUsername)
    }()
}
