//
//  DefaultSDKFoundation.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

public final class DefaultSDKFoundation: SDKFoundation {
    // MARK: Properties

    public static let shared = DefaultSDKFoundation()

    /// - SeeAlso: AppFoundation.apiClient
    private(set) lazy public var apiClient: APIClient = {
        DefaultAPIClient()
    }()
}
