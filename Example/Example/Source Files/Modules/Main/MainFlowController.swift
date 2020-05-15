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
        checkAPIManager()
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
        // swiftlint:disable line_length
        let generatedJWT = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJqd3QtcGdzbW9iaWxlc2RrIiwiaWF0IjoxNTg5NDY3Njg5LjA5ODg3NDEsInBheWxvYWQiOnsiZXhwaXJ5ZGF0ZSI6IjEyXC8yMDIyIiwiYmFzZWFtb3VudCI6MTA1MCwicGFuIjoiNDExMTExMTExMTExMTExMSIsInNlY3VyaXR5Y29kZSI6IjEyMyIsImFjY291bnR0eXBlZGVzY3JpcHRpb24iOiJFQ09NIiwic2l0ZXJlZmVyZW5jZSI6InRlc3RfcGdzbW9iaWxlc2RrNzk0NTgiLCJjdXJyZW5jeWlzbzNhIjoiR0JQIn19.4DANy4Krch5OunHj4ag0UxZTxLPUFVqtPotWDGVLRJA"
        // swiftlint:enable line_length
        appFoundation.apiManager.makeGeneralRequest(alias: "jwt-pgsmobilesdk", jwt: generatedJWT, version: "1.00", requests: [authRequest])
    }
}
