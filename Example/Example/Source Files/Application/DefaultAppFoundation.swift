//
//  DefaultAppFoundation.swift
//  Example
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation
import SecureTradingCore

final class DefaultAppFoundation: AppFoundation {
    public private(set) lazy var apiClient: APIClient = {
        DefaultAPIClient()
    }()
}
