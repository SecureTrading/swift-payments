//
//  MainFlowController.swift
//  Example
//

import SecureTradingUI
import SecureTradingCore
import UIKit

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
            case .didTapShowTestMainScreen:
                self.showTestMainScreen()
            case .didTapShowTestMainFlow:
                self.showTestMainFlow()
            }
        }
        return mainViewController
    }

    // Test UI framework availability
    func showTestMainScreen() {
        let testMainVC = ViewControllerFactory.shared.testMainViewController { [unowned self] in
            self.navigationController.popViewController(animated: true)
        }
        push(testMainVC, animated: true)
    }

    var sdkFlowController: SDKFlowController!
    func showTestMainFlow() {
        sdkFlowController = SDKFlowController(navigationController: navigationController)
        sdkFlowController.presentTestMainFlow()
    }

    private func checkAPIManager() {
        let authRequest = RequestObject(typeDescriptions: [.auth])
        let generatedJWT = ""
        appFoundation.apiManager.makeGeneralRequest(alias: "jwt-pgsmobilesdk", jwt: generatedJWT, version: "1.00", requests: [authRequest])
    }
}
