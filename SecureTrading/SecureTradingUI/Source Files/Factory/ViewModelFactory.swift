//
//  ViewModelFactory.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCore
#endif

internal final class ViewModelFactory {
    private let sdkFoundation = DefaultSDKFoundation.shared

    func testMainViewModel() -> TestMainViewModel {
        return TestMainViewModel(closeButtonIsHidden: true)
    }
}
