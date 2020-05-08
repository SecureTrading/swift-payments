//
//  CardViewModel.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 06/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation
#if !COCOAPODS
import SecureTradingCore
#endif

@objc public final class CardViewModel: NSObject {
    let apiClient: APIClient

    public override init() {
        // check Core dependency
        self.apiClient = DefaultAPIClient()
    }
}
