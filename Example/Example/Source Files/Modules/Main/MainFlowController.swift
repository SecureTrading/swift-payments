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
        let inputViewStyleManager = InputViewStyleManager(titleColor: .brown, textFieldBorderColor: .blue, textFieldBackgroundColor: .yellow, textColor: .purple, placeholderColor: .orange, errorColor: .green, titleFont: UIFont.systemFont(ofSize: 24, weight: .bold), textFont: UIFont.systemFont(ofSize: 24, weight: .regular), placeholderFont: UIFont.systemFont(ofSize: 18, weight: .regular), errorFont: UIFont.systemFont(ofSize: 26, weight: .regular), textFieldImage: nil, titleSpacing: 10, errorSpacing: 10, textFieldHeightMargins: HeightMargins(top: 15, bottom: 15), textFieldBorderWidth: 4, textFieldCornerRadius: 12)
        // swiftlint:enable line_length
        let vc = SingleInputViewsController(view: SingleInputView(inputViewStyleManager: inputViewStyleManager), viewModel: SingleInputViewsModel())
        push(vc, animated: true)
    }

    func showDropInViewController(jwt: String) {
        // swiftlint:disable line_length
        let inputViewStyleManager = InputViewStyleManager(titleColor: .brown, textFieldBorderColor: .blue, textFieldBackgroundColor: .yellow, textColor: .purple, placeholderColor: .orange, errorColor: .green, titleFont: UIFont.systemFont(ofSize: 24, weight: .bold), textFont: UIFont.systemFont(ofSize: 24, weight: .regular), placeholderFont: UIFont.systemFont(ofSize: 18, weight: .regular), errorFont: UIFont.systemFont(ofSize: 26, weight: .regular), textFieldImage: nil, titleSpacing: 15, errorSpacing: 5, textFieldHeightMargins: HeightMargins(top: 15, bottom: 15), textFieldBorderWidth: 4, textFieldCornerRadius: 12)

        let payButtonStyleManager = PayButtonStyleManager(titleColor: .yellow, enabledBackgroundColor: .black, disabledBackgroundColor: .red, borderColor: .blue, titleFont: UIFont.systemFont(ofSize: 30, weight: .bold), spinnerStyle: .whiteLarge, spinnerColor: .orange, buttonContentHeightMargins: HeightMargins(top: 25, bottom: 25), borderWidth: 3, cornerRadius: 12)

        let dropInViewStyleManager = DropInViewStyleManager(inputViewStyleManager: inputViewStyleManager, payButtonStyleManager: payButtonStyleManager, backgroundColor: .lightGray, spacingBeetwenInputViews: 55, insets: UIEdgeInsets(top: 70, left: 80, bottom: -60, right: -80))
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
