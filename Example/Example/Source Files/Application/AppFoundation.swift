//
//  AppFoundation.swift
//  Example
//

import Foundation
import SecureTradingCore

/// Protocol which will be used by almost all flow controllers in the application.
protocol AppFoundation {

    var keys: ApplicationKeys { get }

    /// The common interface of api manager used by the application.
    var apiManager: APIManager { get }
}
