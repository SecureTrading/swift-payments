//
//  SDKFoundation.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

/// Protocol which will be used by almost all flow controllers in the application.
public protocol SDKFoundation {
    /// The common interface of api client used by the application.
    var apiClient: APIClient { get }
}
