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

    var keyboard: KeyboardHelper = KeyboardHelper()

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.handleCardinalWarnings()
    }

    deinit {
        keyboard.unregister()
    }

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        title = LocalizableKeys.DropInViewController.title.localizedString

        customView.setupView { [weak self] (view) in
            guard let self = self else { return }
            guard let dropInView = view as? DropInView else { return }
            dropInView.cardNumberInput.isHidden = self.viewModel.isCardNumberFieldHidden
            dropInView.cvcInput.isHidden = self.viewModel.isCVVFieldHidden
            dropInView.expiryDateInput.isHidden = self.viewModel.isExpiryDateFieldHidden
            (dropInView.cvcInput as? CvcInputView)?.cardType = self.viewModel.cardType
        }
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

        viewModel.transactionSuccessClosure = { [weak self] responseObject, cardReference in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            if let cardRef = cardReference {
                self.eventTriggered?(.successfulPaymentCardAdded(responseObject, LocalizableKeys.DropInViewController.successfulPayment.localizedStringOrEmpty, cardRef))
            } else {
                self.eventTriggered?(.successfulPayment(responseObject, LocalizableKeys.DropInViewController.successfulPayment.localizedStringOrEmpty))
            }
        }

        viewModel.transactionErrorClosure = { [weak self] responseObject, error in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.eventTriggered?(.transactionFailure(responseObject, error))
        }

        viewModel.cardinalAuthenticationErrorClosure = { [weak self] in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.eventTriggered?(.transactionFailure(nil, LocalizableKeys.DropInViewController.cardinalAuthenticationError.localizedStringOrEmpty))
        }

        viewModel.cardinalWarningsCompletion = { [weak self] warningsMessage, warnings in
            guard let self = self else { return }
            self.eventTriggered?(.cardinalWarnings(warningsMessage, warnings))
        }

        viewModel.validationErrorClosure = { [weak self] _, errorCode in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            // In the case of invalid field that is added to the view's hierarchy, indicate the error of invalid input view
            // if the error relates to the input view that is not added to the view's hierarchy, then show alert
            switch errorCode {
            case .invalidPAN:
                self.customView.cardNumberInput.isHidden ?
                    self.eventTriggered?(.transactionFailure(nil, errorCode.message)) :
                    (self.customView.cardNumberInput as? CardNumberInputView)?.showHideError(show: true)
            case .invalidSecurityCode:
                self.customView.cvcInput.isHidden ?
                    self.eventTriggered?(.transactionFailure(nil, errorCode.message)) :
                    (self.customView.cvcInput as? CvcInputView)?.showHideError(show: true)
            case .invalidExpiryDate:
                self.customView.expiryDateInput.isHidden ?
                    self.eventTriggered?(.transactionFailure(nil, errorCode.message)) :
                    (self.customView.expiryDateInput as? ExpiryDateInputView)?.showHideError(show: true)
            default: return
            }
        }
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {
        keyboard.register(target: self)
    }

}

// MARK: Handling appearance/disappearance of keyboard
extension DropInViewController: KeyboardHelperDelegate {
    func keyboardChanged(size: CGSize, animationDuration: TimeInterval, isHidden: Bool) {
        (customView as? DropInView)?.adjustContentInsets(
            UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: isHidden ? 0 : size.height,
                right: 0)
        )
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
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
