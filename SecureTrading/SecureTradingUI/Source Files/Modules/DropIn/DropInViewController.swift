//
//  DropInViewController.swift
//  SecureTradingUI
//

final class DropInViewController: BaseViewController<DropInView, DropInViewModel> {
    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        title = Localizable.DropInViewController.title.text
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {
        customView.payButtonTappedClosure = { [weak self] in
            self?.customView.payButton.startProcessing()
            guard let self = self else { return }
            let isFormValid = self.viewModel.validateForm(view: self.customView)
            if isFormValid {
                print("FORM VALID")
            }
        }
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}
}

private extension Localizable {
    enum DropInViewController: String, Localized {
        case title
    }
}
