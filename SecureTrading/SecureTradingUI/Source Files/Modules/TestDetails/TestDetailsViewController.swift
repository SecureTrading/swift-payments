//
//  TestDetailsViewController.swift
//  SecureTradingUI
//

import UIKit
#if !COCOAPODS
import SecureTradingCore
#endif

final class TestDetailsViewController: BaseViewController<TestDetailsView, TestDetailsViewModel> {

    // MARK: Functions

    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        view.accessibilityIdentifier = "test/view/details"
        title = "Test Details VC"
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {
    }

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}
}
