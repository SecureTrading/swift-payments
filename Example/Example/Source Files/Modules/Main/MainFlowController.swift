//
//  MainFlowController.swift
//  Example
//

import SecureTradingCore
import SecureTradingUI
import SecureTrading3DSecure
import UIKit

final class MainFlowController: BaseNavigationFlowController {
    // MARK: - Properties:

    var sdkFlowController: SDKFlowController!
    private var mainViewModel: MainViewModel?

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
        let viewItems = [
            MainViewModel.Section.onSDK(rows:
                [
                    MainViewModel.Row.performAuthRequestInBackground,
                    MainViewModel.Row.presentSingleInputComponents,
                    MainViewModel.Row.presentPayByCardForm,
                    MainViewModel.Row.showDropInControllerWithWarnings,
                    MainViewModel.Row.showDropInControllerNo3DSecure,
                    MainViewModel.Row.showDropInControllerWithCustomView,
                    MainViewModel.Row.payByCardFromParentReference,
                    MainViewModel.Row.performAccountCheck,
                    MainViewModel.Row.performAccountCheckWithAuth,
                    MainViewModel.Row.subscriptionOnSTEngine,
                    MainViewModel.Row.subscriptionOnMerchantEngine
                ]),
            MainViewModel.Section.onMerchant(rows:
                [
                    MainViewModel.Row.presentWalletForm,
                    MainViewModel.Row.presentAddCardForm
                ])
        ]

        mainViewModel = MainViewModel(items: viewItems)
        let mainViewController = MainViewController(view: MainView(), viewModel: mainViewModel!)
        mainViewController.eventTriggered = { [unowned self] event in
            switch event {
            case .didTapShowTestMainScreen:
                self.showTestMainScreen()
            case .didTapShowTestMainFlow:
                self.showTestMainFlow()
            case .didTapShowSingleInputViews:
                self.showSingleInputViewsSceen()
            case .didTapShowDropInController(let jwt):
                self.showDropInViewController(jwt: jwt, handleCardinalWarnings: false, addCustomView: false)
            case .didTapShowDropInControllerWithWarnings(let jwt):
                self.showDropInViewController(jwt: jwt, handleCardinalWarnings: true, addCustomView: false)
            case .didTapShowDropInControllerNoThreeDQuery(let jwt):
                self.showDropInViewController(jwt: jwt, handleCardinalWarnings: false, addCustomView: false, typeDescriptions: [.auth])
            case .didTapAddCard(let jwt):
                self.showAddCardView(jwt: jwt)
            case .payWithWalletRequest:
                self.showWalletView()
            case .didTapShowDropInControllerWithCustomView(let jwt):
                self.showDropInViewController(jwt: jwt, handleCardinalWarnings: false, addCustomView: true)
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

    func showDropInViewController(jwt: String, handleCardinalWarnings: Bool, addCustomView: Bool, typeDescriptions: [TypeDescription] = [.threeDQuery, .auth]) {
        // swiftlint:disable line_length
        let inputViewStyleManager = InputViewStyleManager(titleColor: UIColor.gray, textFieldBorderColor: UIColor.black.withAlphaComponent(0.8), textFieldBackgroundColor: .clear, textColor: .black, placeholderColor: UIColor.lightGray.withAlphaComponent(0.8), errorColor: UIColor.red.withAlphaComponent(0.8), titleFont: UIFont.systemFont(ofSize: 16, weight: .regular), textFont: UIFont.systemFont(ofSize: 16, weight: .regular), placeholderFont: UIFont.systemFont(ofSize: 16, weight: .regular), errorFont: UIFont.systemFont(ofSize: 12, weight: .regular), textFieldImage: nil, titleSpacing: 5, errorSpacing: 3, textFieldHeightMargins: HeightMargins(top: 10, bottom: 10), textFieldBorderWidth: 1, textFieldCornerRadius: 6)

        let payButtonStyleManager = PayButtonStyleManager(titleColor: .white, enabledBackgroundColor: .black, disabledBackgroundColor: UIColor.lightGray.withAlphaComponent(0.6), borderColor: .clear, titleFont: UIFont.systemFont(ofSize: 16, weight: .medium), spinnerStyle: .white, spinnerColor: .white, buttonContentHeightMargins: HeightMargins(top: 15, bottom: 15), borderWidth: 0, cornerRadius: 6)

        let dropInViewStyleManager = DropInViewStyleManager(inputViewStyleManager: inputViewStyleManager, fieldsToSubmit: [DropInFieldsToSubmit.pan], requestButtonStyleManager: payButtonStyleManager, backgroundColor: .white, spacingBeetwenInputViews: 25, insets: UIEdgeInsets(top: 25, left: 35, bottom: -30, right: -35))

        let toolbarStyleManager = CardinalToolbarStyleManager(textColor: .black, textFont: UIFont.systemFont(ofSize: 16, weight: .bold), backgroundColor: .yellow, headerText: "Trust payment checkout", buttonText: "WHAAT")
        let labelStyleManager = CardinalLabelStyleManager(textColor: .brown, textFont: UIFont.systemFont(ofSize: 13, weight: .heavy), headingTextColor: .green, headingTextFont: UIFont.italicSystemFont(ofSize: 15))

        let verifyButtonStyleManager = CardinalButtonStyleManager(textColor: .white, textFont: UIFont.systemFont(ofSize: 13, weight: .heavy), backgroundColor: UIColor.black.withAlphaComponent(0.5), cornerRadius: 15)
        let continueButtonStyleManager = CardinalButtonStyleManager(textColor: .white, textFont: UIFont.systemFont(ofSize: 13, weight: .heavy), backgroundColor: .blue, cornerRadius: 15)
        let resendButtonStyleManager = CardinalButtonStyleManager(textColor: .white, textFont: UIFont.systemFont(ofSize: 13, weight: .heavy), backgroundColor: .red, cornerRadius: 15)
        let cancelButtonStyleManager = CardinalButtonStyleManager(textColor: .red, textFont: UIFont.systemFont(ofSize: 13, weight: .heavy), backgroundColor: .green, cornerRadius: 15)
        let textBoxStyleManager = CardinalTextBoxStyleManager(textColor: .red, textFont: UIFont.italicSystemFont(ofSize: 13), borderColor: .blue, cornerRadius: 13, borderWidth: 5)

        let cardinalStyleManager = CardinalStyleManager(toolbarStyleManager: toolbarStyleManager, labelStyleManager: labelStyleManager, verifyButtonStyleManager: verifyButtonStyleManager, continueButtonStyleManager: continueButtonStyleManager, resendButtonStyleManager: resendButtonStyleManager, cancelButtonStyleManager: cancelButtonStyleManager, textBoxStyleManager: textBoxStyleManager)

        // custom view provided from example app
        let customDropInView = addCustomView ? DropInCustomView(dropInViewStyleManager: dropInViewStyleManager) : nil

        let isDeferInit = addCustomView

        let dropInVC = ViewControllerFactory.shared.dropInViewController(jwt: jwt, typeDescriptions: typeDescriptions, gatewayType: .eu, username: appFoundation.keys.merchantUsername, isLiveStatus: false, isDeferInit: isDeferInit, customDropInView: customDropInView, dropInViewStyleManager: dropInViewStyleManager, cardTypeToBypass: [], cardinalStyleManager: cardinalStyleManager, payButtonTappedClosureBeforeTransaction: { [unowned self] controller in
            guard let customDropInView = customDropInView else { return }
            // updates JWT with credentialsonfile flag
            guard let updatedJWT = self.mainViewModel?.getJwtTokenWithoutCardData(storeCard: customDropInView.isSaveCardSelected) else { return }
            // update vc with new jwt
            controller.updateJWT(newValue: updatedJWT)
        }, successfulPaymentCompletion: { [unowned self] _, successMessage, cardReference in
            Wallet.shared.add(card: cardReference)
            self.showAlert(controller: self.navigationController, message: successMessage) { _ in
                self.navigationController.popViewController(animated: true)
            }
        }, transactionFailure: { [unowned self] _, errorMessage in
            self.showAlert(controller: self.navigationController, message: errorMessage) { _ in
            }
        }, cardinalWarningsCompletion: { [unowned self] warningsMessage, _ in
            guard handleCardinalWarnings else { return }
            self.showAlert(controller: self.navigationController, message: warningsMessage) { _ in
                self.navigationController.popViewController(animated: true)
            }
        })

        // triggered by UISwitch in SaveCardComponent view
        customDropInView?.saveCardComponentValueChanged = { [weak self] isSelected in
            guard let self = self else { return }
            // updates JWT with credentialsonfile flag
            guard let updatedJWT = self.mainViewModel?.getJwtTokenWithoutCardData(storeCard: isSelected) else { return }
            // update vc with new jwt
            dropInVC.updateJWT(newValue: updatedJWT)
        }

        // swiftlint:enable line_length

        push(dropInVC.viewController, animated: true)
    }

    func showAddCardView(jwt: String) {
        let inputViewStyleManager = InputViewStyleManager.default()
        let addCardButtonStyleManager = AddCardButtonStyleManager.default()
        let dropInViewStyleManager = DropInViewStyleManager(inputViewStyleManager: inputViewStyleManager,
                                                            fieldsToSubmit: DropInFieldsToSubmit.allCases,
                                                            requestButtonStyleManager: addCardButtonStyleManager,
                                                            backgroundColor: .white,
                                                            spacingBeetwenInputViews: 25,
                                                            insets: UIEdgeInsets(top: 25, left: 35, bottom: -30, right: -35))

        let viewController = AddCardViewController(view: AddCardView(dropInViewStyleManager: dropInViewStyleManager),
                                                   viewModel: AddCardViewModel(jwt: jwt,
                                                                               typeDescriptions: [.accountCheck],
                                                                               gatewayType: .eu,
                                                                               username: appFoundation.keys.merchantUsername))
        viewController.eventTriggered = { [weak self] event in
            switch event {
            case .added(let cardReference):
                Wallet.shared.add(card: cardReference)
                self?.navigationController.popViewController(animated: true)
            }
        }

        push(viewController, animated: true)
    }

    func showWalletView() {
        let cards = Wallet.shared.allCards
        let viewItems = [
            WalletViewModel.Section.paymentMethods(rows: cards.map { WalletViewModel.Row.cardReference($0) }),
            WalletViewModel.Section.addMethod(showHeader: !cards.isEmpty, rows: [WalletViewModel.Row.addCard(title: Localizable.WalletViewModel.addPaymentMethod.text)])
        ]
        let viewModel = WalletViewModel(apiManager: appFoundation.apiManager, items: viewItems)
        let view = WalletView()
        view.dataSource = viewModel
        let viewController = WalletViewController(view: view, viewModel: viewModel)
        viewController.eventTriggered = { event in
            switch event {
            case .succesfullTransaction:
                self.navigationController.popViewController(animated: true)
            }
        }
        push(viewController, animated: true)
    }

    // Test UI framework availability
    func showTestMainScreen() {
        let testMainVC = ViewControllerFactory.shared.testMainViewController { [unowned self] in
            self.navigationController.popViewController(animated: true)
        }
        push(testMainVC, animated: true)
    }

    func showTestMainFlow() {
        sdkFlowController = SDKFlowController(navigationController: navigationController)
        sdkFlowController.presentTestMainFlow()
    }

    private func showAlert(controller: UIViewController, message: String, completionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localizable.Alerts.okButton.text, style: .default, handler: completionHandler))
        controller.present(alert, animated: true, completion: nil)
    }
}

private extension Localizable {
    enum WalletViewModel: String, Localized {
        case addPaymentMethod
    }
}
