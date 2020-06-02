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
        case didTapShowDropInController
    }

    private var transparentNavigationBar: TransparentNavigationBar? { return navigationController?.navigationBar as? TransparentNavigationBar }

    /// Callback with triggered event
    var eventTriggered: ((Event) -> Void)?

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        view.accessibilityIdentifier = "home/view/main"
        title = Localizable.MainViewController.title.text
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
            self.eventTriggered?(.didTapShowDropInController)
        }

        viewModel.showAuthSuccess = { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(message: "successful payment")
        }

        viewModel.showAuthError = { [weak self] error in
            guard let self = self else { return }
            self.showAlert(message: error)
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
