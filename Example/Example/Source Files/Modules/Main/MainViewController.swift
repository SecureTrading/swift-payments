//
//  MainViewController.swift
//  Example
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

final class MainViewController: BaseViewController<MainView, MainViewModel> {
    // - SeeAlso: BaseViewController.setupView
    override func setupView() {
        view.accessibilityIdentifier = "home/view/main"
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {}

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}
}
