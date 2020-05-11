//
//  AppFlowController.swift
//  Example
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

final class AppFlowController {
    // MARK: Properties

    private var window: UIWindow

    /// - SeeAlso: FlowController.childFlowController
    private(set) var childFlowController: FlowController?

    /// Class that provides easy access to common dependencies.
    private let appFoundation: AppFoundation

    // MARK: Initializer

    /// Initializes an instance of the receiver.
    ///
    /// - Parameters:
    ///   - appFoundation: Provides easy access to common dependencies
    ///   - window: Application main window
    init(appFoundation: AppFoundation, window: UIWindow) {
        self.appFoundation = appFoundation
        self.window = window
    }

    // MARK: Functions

    /// Function starts work of AppFlowController.
    func start() {
        displayMainScreen()
        window.makeKeyAndVisible()
    }

    /// Sets and displays Main screen
    private func displayMainScreen() {
        let mainFlowController = MainFlowController(appFoundation: appFoundation)
        childFlowController = mainFlowController
        window.rootViewController = mainFlowController.rootViewController
    }

}
