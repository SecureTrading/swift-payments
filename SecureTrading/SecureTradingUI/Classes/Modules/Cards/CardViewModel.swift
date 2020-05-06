//
//  CardViewModel.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 06/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation
import SecureTradingCore

public final class CardViewModel {
    let apiClient: APIClient

    public init() {
        // check Core dependency
        self.apiClient = DefaultAPIClient()
    }
}
