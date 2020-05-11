//
//  TestMainFlowController.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit
#if !COCOAPODS
import SecureTradingCore
#endif

final class TestMainFlowController: BaseNavigationFlowController {
    // MARK: Initalization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter sdkFoundation: Provides easy access to common dependencies
    override init(sdkFoundation: SDKFoundation) {
        super.init(sdkFoundation: sdkFoundation)
        set(setupTestMainScreen())
    }

    // MARK: Functions

    /// Function called to setup Test Main Screen
    ///
    /// - Returns: Object of TestMainViewController
    private func setupTestMainScreen() -> UIViewController {
        let testMainViewController = TestMainViewController(view: TestMainView(), viewModel: TestMainViewModel(apiClient: sdkFoundation.apiClient))
        testMainViewController.eventTriggered = { [unowned self] event in
            switch event {
            case .didTapShowDetails:
                self.showDetailsScreen()
            }
        }
        return testMainViewController
    }

    /// show details screen
    private func showDetailsScreen() {
        let testDetailsFlowController = TestDetailsFlowController(sdkFoundation: sdkFoundation)
        guard let testDetailsController = testDetailsFlowController.rootViewController else { return }
        add(testDetailsFlowController, with: testDetailsController)
        push(testDetailsController, animated: true)
    }
}
