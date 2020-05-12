//
//  SDKFlowController.swift
//  SecureTradingUI
//

import UIKit
#if !COCOAPODS
import SecureTradingCore
#endif

@objc public final class SDKFlowController: NSObject {
    // MARK: Properties

    private var navigationController: UINavigationController

    private var childFlowControllers = [String: FlowController]()

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

    // MARK: Helpers

    /// Adds flow controller to the store.
    ///
    /// - Parameters:
    ///   - flowController: Flow controller which will be added.
    ///   - viewController: View controller which belongs to this flow controller.
    func add(_ flowController: FlowController, with viewController: UIViewController) {
        let viewControllerString = String(describing: viewController)
        childFlowControllers[viewControllerString] = flowController
    }

    /// Removes flow controller attached with given view controller.
    ///
    /// - Parameter viewController: Root view controller of flow controller.
    func removeFlowController(attachedTo viewController: UIViewController) {
        childFlowControllers[String(describing: viewController)] = nil
    }

    // MARK: Flow functions

    public func presentTestMainFlow() {
        let testMainFlowController = TestMainFlowController(sdkFoundation: sdkFoundation, delegate: self)
        testMainFlowController.navigationController.modalPresentationStyle = .fullScreen
        add(testMainFlowController, with: testMainFlowController.rootViewController!)
        navigationController.present(testMainFlowController.navigationController, animated: true, completion: nil)
    }
}

extension SDKFlowController: TestMainFlowControllerDelegate {
    /// - SeeAlso: TestMainFlowControllerDelegate.finishedFlow(in:)
    func finishedFlow(in flowController: TestMainFlowController) {
        removeFlowController(attachedTo: flowController.rootViewController!)
    }
}
