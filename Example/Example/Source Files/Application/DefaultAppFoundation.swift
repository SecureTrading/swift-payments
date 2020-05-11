//
//  DefaultAppFoundation.swift
//  Example
//

import Foundation
import SecureTradingCore

final class DefaultAppFoundation: AppFoundation {
    public private(set) lazy var apiClient: APIClient = {
        DefaultAPIClient()
    }()
}
