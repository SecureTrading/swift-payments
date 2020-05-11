//
//  TestMainViewController.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

public final class TestMainViewController: BaseViewController<TestMainView, TestMainViewModel> {

    // MARK: Properties

    /// Enum describing events that can be triggered by this controller
    enum Event {
        case didTapShowDetails
    }

    /// Callback with triggered event
    var eventTriggered: ((Event) -> Void)?

    // MARK: Functions

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        view.accessibilityIdentifier = "test/view/main"
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
}
