//
//  TestMainViewController.swift
//  SecureTradingUI
//

import UIKit

public final class TestMainViewController: BaseViewController<TestMainView, TestMainViewModel> {
    // MARK: Properties

    /// Enum describing events that can be triggered by this controller
    enum Event {
        case didTapShowDetails
        case dismissScreen
    }

    /// Callback with triggered event
    var eventTriggered: ((Event) -> Void)?

    // MARK: Functions

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        view.accessibilityIdentifier = "test/view/main"
        title = Localizable.TestMainViewController.title.text
        if !viewModel.closeButtonIsHidden {
            setupBarButtons()
        }
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {
        customView.showDetailsButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            self.eventTriggered?(.didTapShowDetails)
        }
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}

    /// Set up top navigation bar buttons
    private func setupBarButtons() {
        let cancelBarButton = UIBarButtonItem(title: Localizable.TestMainViewController.closeButton.text, style: .plain, target: self, action: #selector(closeBarButtonTapped))
        navigationItem.leftBarButtonItem = cancelBarButton
    }

    // MARK: Actions

    /// Action triggered after tapping close bar button
    @objc private func closeBarButtonTapped() {
        eventTriggered?(.dismissScreen)
    }
}

private extension Localizable {
    enum TestMainViewController: String, Localized {
        case title
        case closeButton
    }
}
