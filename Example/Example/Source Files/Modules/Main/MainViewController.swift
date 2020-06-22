//
//  MainViewController.swift
//  Example
//

import UIKit

final class MainViewController: BaseViewController<MainView, MainViewModel> {
    /// Enum describing events that can be triggered by this controller
    enum Event {
        case didTapShowTestMainScreen
        case didTapShowTestMainFlow
        case didTapShowSingleInputViews
        case didTapShowDropInController(String)
        case didTapAddCard(String)
        case payWithWalletRequest
        case didTapShowDropInControllerWithWarnings(String)
        case didTapShowDropInControllerNoThreeDQuery(String)
    }

    private var transparentNavigationBar: TransparentNavigationBar? { return navigationController?.navigationBar as? TransparentNavigationBar }

    /// Callback with triggered event
    var eventTriggered: ((Event) -> Void)?

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        view.accessibilityIdentifier = "home/view/main"

        // Trust Payments logo in navigation bar
        let imageView = UIImageView(image: UIImage(named: "trustPaymentsLogo"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView

        customView.dataSource = viewModel
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {
        customView.showTestMainScreenButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            self.eventTriggered?(.didTapShowTestMainScreen)
        }
        customView.showTestMainFlowButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            self.eventTriggered?(.didTapShowTestMainFlow)
        }
        customView.makeAuthRequestButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            self.viewModel.makeAuthCall()
        }
        customView.showSingleInputViewsButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            self.eventTriggered?(.didTapShowSingleInputViews)
        }
        customView.showDropInControllerButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            guard let jwt = self.viewModel.getJwtTokenWithoutCardData() else { return }
            self.eventTriggered?(.didTapShowDropInController(jwt))
        }
        customView.showDropInControllerWithWarningsButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            guard let jwt = self.viewModel.getJwtTokenWithoutCardData() else { return }
            self.eventTriggered?(.didTapShowDropInControllerWithWarnings(jwt))
        }
        customView.accountCheckRequest = { [weak self] in
            guard let self = self else { return }
            self.viewModel.makeAccountCheckRequest()
        }
        customView.accountCheckWithAuthRequest = { [weak self] in
            guard let self = self else { return }
            self.viewModel.makeAccountCheckWithAuthRequest()
        }
        customView.addCardReferenceRequest = { [weak self] in
            guard let self = self else { return }
            guard let jwt = self.viewModel.getJwtTokenWithoutCardData() else { return }
            self.eventTriggered?(.didTapAddCard(jwt))
        }
        customView.payWithWalletRequest = { [weak self] in
            guard let self = self else { return }
            self.eventTriggered?(.payWithWalletRequest)
        }
        customView.showDropInControllerNoThreeDQuery = { [weak self] in
            guard let self = self else { return }
            guard let jwt = self.viewModel.getJwtTokenWithoutCardData() else { return }
            self.eventTriggered?(.didTapShowDropInControllerNoThreeDQuery(jwt))
        }
        customView.subscriptionOnSTEngineRequest = { [weak self] in
            self?.viewModel.performSubscriptionOnSTEngine()
        }
        customView.subscriptionOnMerchantEngineRequest = { [weak self] in
            self?.viewModel.performSubscriptionOnMerchantEngine()
        }
        customView.showMoreInformation = { [weak self] infoString in
            self?.showAlert(message: infoString)
        }

        viewModel.showAuthSuccess = { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(message: "successful payment")
        }

        viewModel.showRequestSuccess = { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(message: "The request has been successfully completed")
        }

        viewModel.showAuthError = { [weak self] error in
            guard let self = self else { return }
            self.showAlert(message: error)
        }

        StyleManager.shared.highlightViewsValueChanged = { [weak self] highlight in
            self?.customView.highlightIfNeeded(unhighlightColor: UIColor.clear, unhighlightBorderWith: 0)
        }
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}

    // MARK: Helpers

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localizable.Alerts.okButton.text, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

private extension Localizable {
    enum MainViewController: String, Localized {
        case title
    }
}
