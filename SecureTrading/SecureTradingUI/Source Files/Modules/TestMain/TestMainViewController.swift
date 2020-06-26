//
//  TestMainViewController.swift
//  SecureTradingUI
//

import UIKit

#if !COCOAPODS
import SecureTradingCore
#endif

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
        title = LocalizableKeys.TestMainViewController.title.localizedString
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
        let cancelBarButton = UIBarButtonItem(title: LocalizableKeys.TestMainViewController.closeButton.localizedString, style: .plain, target: self, action: #selector(closeBarButtonTapped))
        navigationItem.leftBarButtonItem = cancelBarButton
    }

    // MARK: Actions

    /// Action triggered after tapping close bar button
    @objc private func closeBarButtonTapped() {
        eventTriggered?(.dismissScreen)
    }
}
