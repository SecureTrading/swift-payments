//
//  DropInViewController.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCore
#endif
import UIKit

final class DropInViewController: BaseViewController<DropInView, DropInViewModel> {
    /// Enum describing events that can be triggered by this controller
    enum Event {
        case successfulPayment
        case successfulPaymentCardAdded(STCardReference)
    }

    /// Callback with triggered event
    var eventTriggered: ((Event) -> Void)?

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        title = Localizable.DropInViewController.title.text
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {
        customView.payButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            let isFormValid = self.viewModel.validateForm(view: self.customView)
            if isFormValid {
                self.customView.payButton.startProcessing()
                let cardNumber = self.customView.cardNumberInput.cardNumber
                let cvc = self.customView.cvcInput.cvc
                let expiryDate = self.customView.expiryDateInput.expiryDate
                self.viewModel.isSaveCardEnabled = self.customView.saveCardView.isSaveCardEnabled
                self.viewModel.makeRequest(cardNumber: cardNumber, securityCode: cvc, expiryDate: expiryDate)
            }
        }

        viewModel.showAuthSuccess = { [weak self] (statusCode, cardReference) in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.showAlert(message: Localizable.DropInViewController.successfulPayment.text) { [weak self] _ in
                guard let self = self else { return }
                if let cardRef = cardReference {
                    self.eventTriggered?(.successfulPaymentCardAdded(cardRef))
                } else {
                    self.eventTriggered?(.successfulPayment)
                }
            }
        }

        viewModel.showAuthError = { [weak self] error in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.showAlert(message: error, completionHandler: nil)
        }

        viewModel.showValidationError = { [weak self] error in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
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
    enum DropInViewController: String, Localized {
        case title
        case successfulPayment
    }
}
