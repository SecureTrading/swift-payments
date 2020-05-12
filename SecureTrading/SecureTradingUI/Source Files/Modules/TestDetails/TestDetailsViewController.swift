//
//  TestDetailsViewController.swift
//  SecureTradingUI
//

import UIKit

final class TestDetailsViewController: BaseViewController<TestDetailsView, TestDetailsViewModel> {

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
