//
//  TestMainViewModel.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation
#if !COCOAPODS
import SecureTradingCore
#endif

@objc public final class TestMainViewModel: NSObject {
    /// - SeeAlso: AppFoundation.apiClient
    private let apiClient: APIClient

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiClient: network tasks manager
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}
