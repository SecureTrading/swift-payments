//
//  MainViewModel.swift
//  Example
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation
import SecureTradingCore
import SecureTradingUI

final class MainViewModel {
    // Test Core framework availability
    let apiClient = DefaultAPIClient()
    // Test UI framework availability
    let testMainVC = ViewControllerFactory.shared.testMainViewController
}
