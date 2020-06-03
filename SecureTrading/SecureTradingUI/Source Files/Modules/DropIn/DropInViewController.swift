//
//  DropInViewController.swift
//  SecureTradingUI
//

import UIKit

final class DropInViewController: BaseViewController<DropInView, DropInViewModel> {
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
                //customView.cardNumberInput.cardNumber
                print("FORM VALID")
                // todo make auth req
            }
        }

        viewModel.showAuthSuccess = { [weak self] _ in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            // todo add to localizable
            self.showAlert(message: "successful payment")
        }

        viewModel.showAuthError = { [weak self] error in
            guard let self = self else { return }
            self.customView.payButton.stopProcessing()
            self.showAlert(message: error)
        }
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}

    // MARK: Alerts

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localizable.Alerts.okButton.text, style: .default, handler: nil))
        // todo completion when successful
        present(alert, animated: true, completion: nil)
    }
}

private extension Localizable {
    enum DropInViewController: String, Localized {
        case title
    }
}
