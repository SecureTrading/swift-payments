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

    public func dropInViewController(jwt: String, typeDescriptions: [TypeDescription], gatewayType: GatewayType, username: String) -> UIViewController {
        let viewController = DropInViewController(view: DropInView(), viewModel: DropInViewModel(jwt: jwt, typeDescriptions: typeDescriptions, gatewayType: gatewayType, username: username))
        return viewController
    }

    @objc public func dropInViewController(jwt: String, typeDescriptions: [Int], gatewayType: GatewayType, username: String) -> UIViewController {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        let typeDescriptionsSwift = objcTypes.map { TypeDescription(rawValue: $0.value)! }
        let viewController = DropInViewController(view: DropInView(), viewModel: DropInViewModel(jwt: jwt, typeDescriptions: typeDescriptionsSwift, gatewayType: gatewayType, username: username))
        return viewController
    }
}
