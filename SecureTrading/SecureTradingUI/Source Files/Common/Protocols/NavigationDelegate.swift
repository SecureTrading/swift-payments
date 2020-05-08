//
//  NavigationDelegate.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

protocol NavigationDelegate: AnyObject {
    /// Method called to push new viewcontroller to the navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: View controller which is going to be presented.
    ///   - animated: Indicates if push should be animated.
    func push(_ viewController: UIViewController, animated: Bool)

    /// Adds flow controller to the store.
    ///
    /// - Parameters:
    ///   - flowController: Flow controller which will be added.
    ///   - viewController: View controller which belongs to this flow controller.
    func add(_ flowController: FlowController, with viewController: UIViewController)

    /// - Parameter viewController: Root view controller of flow controller.
    func removeFlowController(attachedTo viewController: UIViewController)
}
