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

    let closeButtonIsHidden: Bool

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiClient: network tasks manager
    init(apiClient: APIClient, closeButtonIsHidden: Bool) {
        self.apiClient = apiClient
        self.closeButtonIsHidden = closeButtonIsHidden
    }
}
