//
//  SDKFlowController.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit
#if !COCOAPODS
import SecureTradingCore
#endif

@objc public final class SDKFlowController: NSObject {

    // MARK: Properties

    private var navigationController: UINavigationController

    /// - SeeAlso: FlowController.childFlowController
    private(set) var childFlowController: FlowController?

    /// Class that provides easy access to common dependencies.
    private let sdkFoundation: SDKFoundation

    // MARK: Initializer

    /// Initializes an instance of the receiver.
    ///
    /// - Parameters:
    ///   - sdkFoundation: Provides easy access to common dependencies
    ///   - navigationController: Application UINavigationController
    public init(sdkFoundation: SDKFoundation = DefaultSDKFoundation.shared, navigationController: UINavigationController) {
        self.sdkFoundation = sdkFoundation
        self.navigationController = navigationController
    }

    // MARK: Functions

    public func presentTestMainFlow() {
        let testMainFlowController = TestMainFlowController(sdkFoundation: sdkFoundation)
        childFlowController = testMainFlowController
        navigationController.present(testMainFlowController.navigationController, animated: true, completion: nil)
    }

}
