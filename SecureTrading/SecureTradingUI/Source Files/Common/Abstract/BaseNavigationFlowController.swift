//
//  BaseNavigationFlowController.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit
#if !COCOAPODS
import SecureTradingCore
#endif

class BaseNavigationFlowController: NSObject, NavigationFlowController {
    // MARK: Properties

    var childFlowController: FlowController? {
        guard let currentViewController = navigationController.viewControllers.last else { return nil }
        return childFlowControllers[String(describing: currentViewController)]
    }

    var childFlowControllers = [String: FlowController]()

    let navigationController: UINavigationController

    /// Class that provides easy access to common dependencies.
    let sdkFoundation: SDKFoundation

    /// Custom navigation controller delegate accessor.
    var customNavigationControllerDelegate: CustomBackNavigationControllerDelegate? {
        get { return (navigationController as? CustomBackNavigationController)?.customDelegate }
        set { (navigationController as? CustomBackNavigationController)?.customDelegate = newValue }
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter appFoundation: Provides easy access to common dependencies.
    init(sdkFoundation: SDKFoundation) {
        self.sdkFoundation = sdkFoundation
        navigationController = CustomBackNavigationController(navigationBarClass: TransparentNavigationBar.self, toolbarClass: nil)
        super.init()
        navigationController.delegate = self
    }

    /// Setups viewcontroller's bar buttons and pushes it to navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: View controller to push.
    ///   - animated: Indicates if should be animated.
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    /// Setups viewcontroller's bar buttons and replaces current navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: View controller to push.
    ///   - animated: Indicates if should be animated.
    func set(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.setViewControllers([viewController], animated: animated)
    }

    /// Adds flow controller to the store.
    ///
    /// - Parameters:
    ///   - flowController: Flow controller which will be added.
    ///   - viewController: View controller which belongs to this flow controller.
    func add(_ flowController: FlowController, with viewController: UIViewController) {
        let viewControllerString = String(describing: viewController)
        if flowController is BaseFlowController {
            (flowController as? BaseFlowController)?.navigationDelegate = self
        }
        childFlowControllers[viewControllerString] = flowController
    }

    /// Removes flow controller attached with given view controller.
    ///
    /// - Parameter viewController: Root view controller of flow controller.
    func removeFlowController(attachedTo viewController: UIViewController) {
        childFlowControllers[String(describing: viewController)] = nil
    }
}

extension BaseNavigationFlowController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        guard
            let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            let toViewController = navigationController.transitionCoordinator?.viewController(forKey: .to)
        else {
            return
        }
        let fromIndex = navigationController.viewControllers.firstIndex(of: fromViewController) ?? 99
        let toIndex = navigationController.viewControllers.firstIndex(of: toViewController) ?? 98

        if fromIndex > toIndex { // && toIndex == 0 {
            removeFlowController(attachedTo: fromViewController)
        }
    }
}

extension BaseNavigationFlowController: NavigationDelegate {}
