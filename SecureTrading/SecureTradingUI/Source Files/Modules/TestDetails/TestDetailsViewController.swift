//
//  TestDetailsViewController.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

final class TestDetailsViewController: BaseViewController<TestDetailsView, TestDetailsViewModel> {

    // MARK: Properties

    // MARK: Functions

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        view.accessibilityIdentifier = "test/view/details"
        title = Localizable.TestDetailsViewController.title.text
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}
}

private extension Localizable {
    enum TestDetailsViewController: String, Localized {
        case title
    }
}
