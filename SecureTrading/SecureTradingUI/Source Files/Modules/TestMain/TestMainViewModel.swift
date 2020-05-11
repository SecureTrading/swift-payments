//
//  TestMainViewModel.swift
//  SecureTradingUI
//

import Foundation
#if !COCOAPODS
import SecureTradingCore
#endif

public final class TestMainViewModel: NSObject {
    /// - SeeAlso: AppFoundation.apiClient
    private let apiClient: APIClient

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiClient: network tasks manager
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}
