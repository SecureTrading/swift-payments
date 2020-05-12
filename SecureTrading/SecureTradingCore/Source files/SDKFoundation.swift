//
//  SDKFoundation.swift
//  SecureTradingCore
//

/// Protocol which will be used by almost all flow controllers in the application.
public protocol SDKFoundation {
    /// The common interface of api client used by the application.
    var apiClient: APIClient { get }
}
