//
//  ViewControllerFactory.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCore
#endif
import Foundation
import UIKit

@objc public final class ViewControllerFactory: NSObject {
    @objc public static let shared = ViewControllerFactory()

    private let viewModelFactory = ViewModelFactory()

    private override init() {}

    @objc public func testMainViewController(didTapShowDetails: @escaping () -> Void) -> UIViewController {
        let viewController = TestMainViewController(view: TestMainView(), viewModel: viewModelFactory.testMainViewModel())
        viewController.eventTriggered = { event in
            switch event {
            case .didTapShowDetails:
                didTapShowDetails()
            case .dismissScreen:
                break
            }
        }
        return viewController
    }

    @objc public func dropInViewController(jwt: String, gatewayType: GatewayType, username: String) -> UIViewController {
        let viewController = DropInViewController(view: DropInView(), viewModel: DropInViewModel(jwt: jwt, gatewayType: gatewayType, username: username))
        return viewController
    }
}
