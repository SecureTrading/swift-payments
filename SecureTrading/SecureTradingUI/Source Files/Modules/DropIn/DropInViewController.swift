//
//  DropInViewController.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTrading3DSecure
import SecureTradingCore
#endif
import UIKit

final class DropInViewController: BaseViewController<DropInView, DropInViewModel> {
    /// Enum describing events that can be triggered by this controller
    enum Event {
        case successfulPayment(ResponseSettleStatus)
        case successfulPaymentCardAdded(ResponseSettleStatus, STCardReference)
        case transactionFailure
        case cardinalWarnings(String, [CardinalInitWarnings])
    }

    /// Callback with triggered event
    var eventTriggered: ((Event) -> Void)?

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.handleCardinalWarnings()
    }

    deinit {
        removeObservers()
    }

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
                self.viewModel.performTransaction(cardNumber: cardNumber, securityCode: cvc, expiryDate: expiryDate)
            }
        }

        viewModel.showTransactionSuccess = { [weak self] responseSettleStatus, cardReference in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.showAlert(message: Localizable.DropInViewController.successfulPayment.text) { [weak self] _ in
                guard let self = self else { return }
                if let cardRef = cardReference {
                    self.eventTriggered?(.successfulPaymentCardAdded(responseSettleStatus, cardRef))
                } else {
                    self.eventTriggered?(.successfulPayment(responseSettleStatus))
                }
            }
        }

        viewModel.showTransactionError = { [weak self] error in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.showAlert(
                message: error,
                completionHandler: { [weak self] _ in
                    guard let self = self else { return }
                    self.eventTriggered?(.transactionFailure)
                }
            )
        }

        viewModel.showCardinalAuthenticationError = { [weak self] in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.showAlert(
                message: Localizable.DropInViewController.cardinalAuthenticationError.text,
                completionHandler: { [weak self] _ in
                    guard let self = self else { return }
                    self.eventTriggered?(.transactionFailure)
                }
            )
        }

        viewModel.cardinalWarningsCompletion = { [weak self] warningsMessage, warnings in
            guard let self = self else { return }
            self.eventTriggered?(.cardinalWarnings(warningsMessage, warnings))
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
    override func setupProperties() {
        addObservers()
    }

    // MARK: Handling appearance/disappearance of keyboard

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let duration = TimeInterval(exactly: keyboardAnimationDuration)
        else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        customView.moveUpTableView(height: keyboardHeight)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard
            let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let duration = TimeInterval(exactly: keyboardAnimationDuration)
        else { return }
        customView.moveDownTableView()
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

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
        case cardinalAuthenticationError
    }
}
