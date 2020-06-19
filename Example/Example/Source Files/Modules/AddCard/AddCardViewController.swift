//
//  AddCardViewController.swift
//  Example
//

import UIKit

final class AddCardViewController: BaseViewController<AddCardView, AddCardViewModel> {
    /// Enum describing events that can be triggered by this controller
    enum Event {
        case added(cardReference: STCardReference?)
    }

    /// Callback with triggered event
    var eventTriggered: ((Event) -> Void)?

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        title = Localizable.AddCardViewController.title.text
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {
        customView.addCardButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            let isFormValid = self.viewModel.validateForm(view: self.customView)
            if isFormValid {
                self.customView.addCardButton.startProcessing()
                let cardNumber = self.customView.cardNumberInput.cardNumber
                let cvc = self.customView.cvcInput.cvc
                let expiryDate = self.customView.expiryDateInput.expiryDate

                self.viewModel.makeRequest(cardNumber: cardNumber, securityCode: cvc, expiryDate: expiryDate)
            }
        }

        viewModel.showCardAddedSuccess = { [weak self] cardReference in
            guard let self = self else { return }
            self.customView.addCardButton.stopProcessing()
            self.showAlert(message: Localizable.AddCardViewController.cardAdded.text) { [weak self] _ in
                guard let self = self else { return }
                self.eventTriggered?(.added(cardReference: cardReference))
            }
        }

        viewModel.showAuthError = { [weak self] error in
            guard let self = self else { return }
            self.customView.addCardButton.stopProcessing()
            self.showAlert(message: error, completionHandler: nil)
        }

        viewModel.showValidationError = { [weak self] error in
            guard let self = self else { return }
            self.customView.addCardButton.stopProcessing()
            switch error {
            case .invalidPAN: self.customView.cardNumberInput.showHideError(show: true)
            case .invalidSecurityCode: self.customView.cvcInput.showHideError(show: true)
            case .invalidExpiryDate: self.customView.expiryDateInput.showHideError(show: true)
            default: return
            }
        }
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}

    // MARK: Alerts

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
    enum AddCardViewController: String, Localized {
        case title
        case cardAdded
    }
}
