//
//  TestDetailsViewModel.swift
//  SecureTradingUI
//

import Foundation
#if !COCOAPODS
import SecureTradingCore
#endif

final class TestDetailsViewModel: NSObject {
    /// - SeeAlso: AppFoundation.apiClient
    private let apiClient: APIClient

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiClient: network tasks manager
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}
