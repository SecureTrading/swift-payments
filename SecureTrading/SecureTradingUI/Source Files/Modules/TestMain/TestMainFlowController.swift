//
//  TestMainFlowController.swift
//  SecureTradingUI
//

import UIKit
#if !COCOAPODS
import SecureTradingCore
#endif

protocol TestMainFlowControllerDelegate: AnyObject {
    /// Called when TestMainFlowController ended its job.
    ///
    /// - Parameter flowController: Instance of TestMainFlowController which has ended its job.
    func finishedFlow(in flowController: TestMainFlowController)
}

final class TestMainFlowController: BaseNavigationFlowController {

    /// Flow controller delegate.
    private weak var delegate: TestMainFlowControllerDelegate?

    // MARK: Initalization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter sdkFoundation: Provides easy access to common dependencies
    /// - Parameter delegate: TestMainFlowController delegate
    init(sdkFoundation: SDKFoundation, delegate: TestMainFlowControllerDelegate?) {
        super.init(sdkFoundation: sdkFoundation)
        self.delegate = delegate
        set(setupTestMainScreen())
    }

    // MARK: Functions

    /// Function called to setup Test Main Screen
    ///
    /// - Returns: Object of TestMainViewController
    private func setupTestMainScreen() -> UIViewController {
        let testMainViewController = TestMainViewController(view: TestMainView(), viewModel: TestMainViewModel(closeButtonIsHidden: false))
        testMainViewController.eventTriggered = { [unowned self] event in
            switch event {
            case .didTapShowDetails:
                self.showDetailsScreen()
            case .dismissScreen:
                self.rootViewController?.dismiss(animated: true)
                self.delegate?.finishedFlow(in: self)
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
