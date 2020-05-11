//
//  MainFlowController.swift
//  Example
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit
import SecureTradingUI

final class MainFlowController: BaseNavigationFlowController {
    // MARK: Initalization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter appFoundation: Provides easy access to common dependencies
    override init(appFoundation: AppFoundation) {
        super.init(appFoundation: appFoundation)
        set(setupMainScreen())
    }

    // MARK: Functions

    /// Function called to setup Main Screen
    ///
    /// - Returns: Object of MainViewController
    private func setupMainScreen() -> UIViewController {
        let mainViewController = MainViewController(view: MainView(), viewModel: MainViewModel())
        mainViewController.eventTriggered = { [unowned self] event in
            switch event {
            case .didTapShowTestMain:
                self.showTestMainScreen()
            }
        }
        return mainViewController
    }

    // Test UI framework availability
    func showTestMainScreen() {
        let testMainVC = ViewControllerFactory.shared.testMainViewController()
        push(testMainVC, animated: true)
    }
}
