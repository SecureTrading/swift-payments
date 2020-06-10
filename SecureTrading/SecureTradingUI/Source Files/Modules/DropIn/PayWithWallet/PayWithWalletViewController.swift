//
//  PayWithWalletViewController.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCore
#endif
import UIKit

final class PayWithWalletViewController: BaseViewController<PayWithWalletView, PayWithWalletViewModel> {
    /// Enum describing events that can be triggered by this controller
    enum Event {
        case added(cardReference: STCardReference?)
    }

    /// Callback with triggered event
    var eventTriggered: ((Event) -> Void)?

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        title = Localizable.PayWithWalletViewController.title.text
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {
        customView.addCardButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
//            let isFormValid = self.viewModel.validateForm(view: self.customView)
//            if isFormValid {
//                self.customView.payButton.startProcessing()
//                let cardNumber = self.customView.cardNumberInput.cardNumber
//                let cvc = self.customView.cvcInput.cvc
//                let expiryDate = self.customView.expiryDateInput.expiryDate
//
//                self.viewModel.makeRequest(cardNumber: cardNumber, securityCode: cvc, expiryDate: expiryDate)
            }
        }
}

private extension Localizable {
    enum PayWithWalletViewController: String, Localized {
        case title
        case pay
    }
}
