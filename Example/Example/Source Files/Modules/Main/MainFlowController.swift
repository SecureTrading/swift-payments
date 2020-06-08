//
//  MainFlowController.swift
//  Example
//

import SecureTradingCore
import SecureTradingUI
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
        let mainViewController = MainViewController(view: MainView(), viewModel: MainViewModel(apiManager: appFoundation.apiManager))
        mainViewController.eventTriggered = { [unowned self] event in
            switch event {
            case .didTapShowTestMainScreen:
                self.showTestMainScreen()
            case .didTapShowTestMainFlow:
                self.showTestMainFlow()
            case .didTapShowSingleInputViews:
                self.showSingleInputViewsSceen()
            case .didTapShowDropInController(let jwt):
                self.showDropInViewController(jwt: jwt)
            }
        }
        return mainViewController
    }

    func showSingleInputViewsSceen() {
        // swiftlint:disable line_length
        let inputViewStyleManager = InputViewStyleManager(titleColor: UIColor.gray, textFieldBorderColor: UIColor.black.withAlphaComponent(0.8), textFieldBackgroundColor: .clear, textColor: .black, placeholderColor: UIColor.lightGray.withAlphaComponent(0.8), errorColor: UIColor.red.withAlphaComponent(0.8), titleFont: UIFont.systemFont(ofSize: 16, weight: .regular), textFont: UIFont.systemFont(ofSize: 16, weight: .regular), placeholderFont: UIFont.systemFont(ofSize: 16, weight: .regular), errorFont: UIFont.systemFont(ofSize: 12, weight: .regular), textFieldImage: nil, titleSpacing: 5, errorSpacing: 3, textFieldHeightMargins: HeightMargins(top: 10, bottom: 10), textFieldBorderWidth: 1, textFieldCornerRadius: 6)
        // swiftlint:enable line_length
        let vc = SingleInputViewsController(view: SingleInputView(inputViewStyleManager: inputViewStyleManager), viewModel: SingleInputViewsModel())
        push(vc, animated: true)
    }

    func showDropInViewController(jwt: String) {
        // swiftlint:disable line_length
        let inputViewStyleManager = InputViewStyleManager(titleColor: UIColor.gray, textFieldBorderColor: UIColor.black.withAlphaComponent(0.8), textFieldBackgroundColor: .clear, textColor: .black, placeholderColor: UIColor.lightGray.withAlphaComponent(0.8), errorColor: UIColor.red.withAlphaComponent(0.8), titleFont: UIFont.systemFont(ofSize: 16, weight: .regular), textFont: UIFont.systemFont(ofSize: 16, weight: .regular), placeholderFont: UIFont.systemFont(ofSize: 16, weight: .regular), errorFont: UIFont.systemFont(ofSize: 12, weight: .regular), textFieldImage: nil, titleSpacing: 5, errorSpacing: 3, textFieldHeightMargins: HeightMargins(top: 10, bottom: 10), textFieldBorderWidth: 1, textFieldCornerRadius: 6)

        let payButtonStyleManager = PayButtonStyleManager(titleColor: .white, enabledBackgroundColor: .black, disabledBackgroundColor: UIColor.lightGray.withAlphaComponent(0.8), borderColor: .clear, titleFont: UIFont.systemFont(ofSize: 16, weight: .medium), spinnerStyle: .white, spinnerColor: .white, buttonContentHeightMargins: HeightMargins(top: 15, bottom: 15), borderWidth: 0, cornerRadius: 6)

        let dropInViewStyleManager = DropInViewStyleManager(inputViewStyleManager: inputViewStyleManager, payButtonStyleManager: payButtonStyleManager, backgroundColor: .white, spacingBeetwenInputViews: 25, insets: UIEdgeInsets(top: 25, left: 35, bottom: -30, right: -35))
        // swiftlint:enable line_length

        let dropInVC = ViewControllerFactory.shared.dropInViewController(jwt: jwt, typeDescriptions: [.auth], gatewayType: .eu, username: appFoundation.keys.merchantUsername, dropInViewStyleManager: dropInViewStyleManager) { [unowned self] in
            self.navigationController.popViewController(animated: true)
        }
        push(dropInVC, animated: true)
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
}
