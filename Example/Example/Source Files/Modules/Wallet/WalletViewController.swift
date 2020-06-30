//
//  WalletViewController.swift
//  Example
//

import UIKit

final class WalletViewController: BaseViewController<WalletView, WalletViewModel> {
    /// Enum describing events that can be triggered by this controller
    enum Event {
        case succesfullTransaction
    }
    /// Callback with triggered event
    var eventTriggered: ((Event) -> Void)?

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        title = Localizable.WalletViewController.title.text
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {
        customView.payWithWalletRequest = { [weak self] in
            guard let self = self else { return }
            // process payment
            self.customView.payButton.startProcessing()
            self.viewModel.performAuthRequest()
        }

        customView.cardFromWalletSelected = { [weak self] card in
            guard let self = self else { return }
            self.viewModel.cardSelected(card)
        }

        customView.addNewPaymentMethod = { [weak self] in
            guard let self = self else { return }
            guard let jwt = self.viewModel.getJwtTokenWithoutCardData(storeCard: true) else { return }

            let inputViewStyleManager = InputViewStyleManager.default()
            let addCardButtonStyleManager = AddCardButtonStyleManager.default()
            let dropInViewStyleManager = DropInViewStyleManager(inputViewStyleManager: inputViewStyleManager,
                                                                visibleFields: DropInViewVisibleFields.allCases,
                                                                requestButtonStyleManager: addCardButtonStyleManager,
                                                                backgroundColor: .white,
                                                                spacingBeetwenInputViews: 25,
                                                                insets: UIEdgeInsets(top: 25, left: 35, bottom: -30, right: -35))

            let viewController = AddCardViewController(view: AddCardView(dropInViewStyleManager: dropInViewStyleManager),
                                                       viewModel: AddCardViewModel(jwt: jwt,
                                                                                   typeDescriptions: [.accountCheck],
                                                                                   gatewayType: .eu,
                                                                                   username: self.viewModel.getUsername))
            viewController.eventTriggered = { [weak self] event in
                switch event {
                case .added(let cardReference):
                    Wallet.shared.add(card: cardReference)
                    self?.viewModel.addNewCard(cardReference)
                    self?.customView.reloadCards()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        }

        viewModel.showRequestSuccess = { [weak self] cardReference in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.showAlert(message: Localizable.WalletViewController.paid.text) { [weak self] _ in
                guard let self = self else { return }
                self.eventTriggered?(.succesfullTransaction)
            }
        }
        
        viewModel.showAuthError = { [weak self] error in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.showAlert(message: error, completionHandler: nil)
        }
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}

    /// shows an alert
    /// - Parameters:
    ///   - message: alert message
    ///   - completionHandler: Closure triggered when the alert button is pressed
    private func showAlert(message: String, completionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localizable.Alerts.okButton.text, style: .default, handler: completionHandler))
        present(alert, animated: true, completion: nil)
    }
}

private extension Localizable {
    enum WalletViewController: String, Localized {
        case title
        case paid
    }
}
