//
//  DefaultSDKFoundation.swift
//  SecureTradingCore
//

public final class DefaultSDKFoundation: SDKFoundation {
    // MARK: Properties

    public static let shared = DefaultSDKFoundation()

    /// - SeeAlso: AppFoundation.apiClient
    private(set) lazy public var apiClient: APIClient = {
        DefaultAPIClient()
    }()
}
