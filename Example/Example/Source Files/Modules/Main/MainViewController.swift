//
//  MainViewController.swift
//  Example
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
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
