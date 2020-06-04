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

    /// creates instances of the DropInViewController
    /// - Parameters:
    ///   - jwt: jwt: jwt token
    ///   - typeDescriptions: request types (AUTH, THREEDQUERY...)
    ///   - gatewayType: gateway type (us or european)
    ///   - username: merchant's username
    ///   - successfulPaymentCompletion: Closure triggered by pressing the button in the successful payment alert
    /// - Returns: instance of DropInViewController
    public func dropInViewController(jwt: String, typeDescriptions: [TypeDescription], gatewayType: GatewayType, username: String, successfulPaymentCompletion: @escaping () -> Void) -> UIViewController {
        let viewController = DropInViewController(view: DropInView(inputViewStyleManager: nil), viewModel: DropInViewModel(jwt: jwt, typeDescriptions: typeDescriptions, gatewayType: gatewayType, username: username))
        viewController.eventTriggered = { event in
            switch event {
            case .successfulPayment:
                successfulPaymentCompletion()
            }
        }
        return viewController
    }

    // objc workaround
    /// creates instances of the DropInViewController
    /// - Parameters:
    ///   - jwt: jwt: jwt token
    ///   - typeDescriptions: request types (AUTH, THREEDQUERY...)
    ///   - gatewayType: gateway type (us or european)
    ///   - username: merchant's username
    ///   - successfulPaymentCompletion: Closure triggered by pressing the button in the successful payment alert
    /// - Returns: instance of DropInViewController
    @objc public func dropInViewController(jwt: String, typeDescriptions: [Int], gatewayType: GatewayType, username: String, successfulPaymentCompletion: @escaping () -> Void) -> UIViewController {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        let typeDescriptionsSwift = objcTypes.map { TypeDescription(rawValue: $0.value)! }
        return self.dropInViewController(jwt: jwt, typeDescriptions: typeDescriptionsSwift, gatewayType: gatewayType, username: username, successfulPaymentCompletion: successfulPaymentCompletion)
    }
}
