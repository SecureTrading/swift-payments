//
//  DropInViewController.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTrading3DSecure
import SecureTradingCore
#endif
import UIKit

@objc public protocol DropInController: UIPresentable {
    @objc func updateJWT(newValue: String)
}

final class DropInViewController: BaseViewController<DropInViewProtocol, DropInViewModel> {
    /// Enum describing events that can be triggered by this controller
    enum Event {
        case successfulPayment(JWTResponseObject, String)
        case successfulPaymentCardAdded(JWTResponseObject, String, STCardReference)
        case transactionFailure(JWTResponseObject?, String)
        case payButtonTappedClosureBeforeTransaction(DropInController)
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
                self.eventTriggered?(.payButtonTappedClosureBeforeTransaction(self))
                self.customView.payButton.startProcessing()
                let cardNumber = self.customView.cardNumberInput.cardNumber
                let cvc = self.customView.cvcInput.cvc
                let expiryDate = self.customView.expiryDateInput.expiryDate
                self.viewModel.performTransaction(cardNumber: cardNumber, securityCode: cvc, expiryDate: expiryDate)
            }
        }

        viewModel.showTransactionSuccess = { [weak self] responseObject, cardReference in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            if let cardRef = cardReference {
                self.eventTriggered?(.successfulPaymentCardAdded(responseObject, Localizable.DropInViewController.successfulPayment.text, cardRef))
            } else {
                self.eventTriggered?(.successfulPayment(responseObject, Localizable.DropInViewController.successfulPayment.text))
            }
        }

        viewModel.showTransactionError = { [weak self] responseObject, error in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.eventTriggered?(.transactionFailure(responseObject, error))
        }

        viewModel.showCardinalAuthenticationError = { [weak self] in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.eventTriggered?(.transactionFailure(nil, Localizable.DropInViewController.cardinalAuthenticationError.text))
        }

        viewModel.cardinalWarningsCompletion = { [weak self] warningsMessage, warnings in
            guard let self = self else { return }
            self.eventTriggered?(.cardinalWarnings(warningsMessage, warnings))
        }

        viewModel.showValidationError = { [weak self] error in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            switch error {
            case .invalidPAN: (self.customView.cardNumberInput as? CardNumberInputView)?.showHideError(show: true)
            case .invalidSecurityCode: (self.customView.cvcInput as? CvcInputView)?.showHideError(show: true)
            case .invalidExpiryDate: (self.customView.expiryDateInput as? ExpiryDateInputView)?.showHideError(show: true)
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
        (customView as? DropInView)?.moveUpTableView(height: keyboardHeight) // todo improve
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard
            let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let duration = TimeInterval(exactly: keyboardAnimationDuration)
        else { return }
        (customView as? DropInView)?.moveDownTableView() // todo improve
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

extension DropInViewController: DropInController {
    func updateJWT(newValue: String) {
        viewModel.updateJWT(newValue: newValue)
    }

    var viewController: UIViewController {
        return self
    }
}

private extension Localizable {
    enum DropInViewController: String, Localized {
        case title
        case successfulPayment
        case cardinalAuthenticationError
    }
}
