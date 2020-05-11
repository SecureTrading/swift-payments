//
//  ViewModelFactory.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

#if !COCOAPODS
import SecureTradingCore
#endif

internal final class ViewModelFactory {
    private let sdkFoundation = DefaultSDKFoundation.shared

    func testMainViewModel() -> TestMainViewModel {
        return TestMainViewModel(apiClient: sdkFoundation.apiClient)
    }
}
