//
//  DefaultSDKFoundation.swift
//  SecureTradingCore
//

public final class DefaultSDKFoundation: SDKFoundation {
    // MARK: Properties

    public static let shared = DefaultSDKFoundation()

    /// - SeeAlso: SDKFoundation.apiManager
    private(set) lazy public var apiManager: APIManager = {
        APIManager()
    }()
}
