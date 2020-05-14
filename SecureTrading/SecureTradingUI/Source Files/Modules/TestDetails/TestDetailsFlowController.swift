//
//  TestDetailsFlowController.swift
//  SecureTradingUI
//

import UIKit
#if !COCOAPODS
import SecureTradingCore
#endif

final class TestDetailsFlowController: BaseFlowController {
    // MARK: Parameters

    /// Provides easy access to common dependencies
    private var sdkFoundation: SDKFoundation

    // MARK: Initalization

    /// Initalizes an instance of the receiver.
    ///
    /// - Parameters:
    ///   - sdkFoundation: Provides access to common dependencies.
    init(sdkFoundation: SDKFoundation) {
        self.sdkFoundation = sdkFoundation
        super.init()
        rootViewController = setupDetailsViewController()
    }

    // MARK: Functions

    /// Setups place details view controller.
    ///
    /// - Returns: Returns place details view controller.
    private func setupDetailsViewController() -> UIViewController {
        let testDetailsViewController = TestDetailsViewController(view: TestDetailsView(), viewModel: TestDetailsViewModel())
        return testDetailsViewController
    }
}
