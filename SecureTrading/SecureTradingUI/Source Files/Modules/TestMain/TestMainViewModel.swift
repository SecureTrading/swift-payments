//
//  TestMainViewModel.swift
//  SecureTradingUI
//

import Foundation
#if !COCOAPODS
import SecureTradingCore
#endif

public final class TestMainViewModel: NSObject {

    let closeButtonIsHidden: Bool

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter closeButtonIsHidden: if it should add a close button to navBar
    init(closeButtonIsHidden: Bool) {
        self.closeButtonIsHidden = closeButtonIsHidden
    }
}
