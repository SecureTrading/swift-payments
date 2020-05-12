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
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}
}

private extension Localizable {
    enum MainViewController: String, Localized {
        case title
    }
}
