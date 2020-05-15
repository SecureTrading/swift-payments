//
//  DefaultAppFoundation.swift
//  Example
//

import Foundation
import SecureTradingCore

final class DefaultAppFoundation: AppFoundation {
    /// - SeeAlso: AppFoundation.apiManager
    private(set) lazy var apiManager: APIManager = {
        DefaultAPIManager(gatewayType: .european, username: "jwt-pgsmobilesdk")
    }()
}
