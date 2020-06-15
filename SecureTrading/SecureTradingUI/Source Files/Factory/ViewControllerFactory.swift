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
    ///   - dropInViewStyleManager: instance of manager to customize view
    ///   - isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment - default behaviour)
    ///   - isDeferInit: It says when the connection with sdk Cardinal Commerce is initiated, whether at the beginning or only after accepting the form (true value)
    /// - Returns: instance of DropInViewController
    public func dropInViewController(jwt: String, typeDescriptions: [TypeDescription], gatewayType: GatewayType, username: String, isLiveStatus: Bool = false, isDeferInit: Bool = false, dropInViewStyleManager: DropInViewStyleManager? = nil, successfulPaymentCompletion: @escaping () -> Void, cardinalWarningsCompletion: (() -> Void)? = nil) -> UIViewController {
        let viewController = DropInViewController(view: DropInView(dropInViewStyleManager: dropInViewStyleManager), viewModel: DropInViewModel(jwt: jwt, typeDescriptions: typeDescriptions, gatewayType: gatewayType, username: username, isLiveStatus: isLiveStatus, isDeferInit: isDeferInit))
        viewController.eventTriggered = { event in
            switch event {
            case .successfulPayment:
                successfulPaymentCompletion()
            case .cardinalWarnings:
                cardinalWarningsCompletion?()
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
    ///   - dropInViewStyleManager: instance of manager to customize view
    ///   - isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment - default behaviour)
    ///   - isDeferInit: It says when the connection with sdk Cardinal Commerce is initiated, whether at the beginning or only after accepting the form (true value)
    /// - Returns: instance of DropInViewController
    @objc public func dropInViewController(jwt: String, typeDescriptions: [Int], gatewayType: GatewayType, username: String, isLiveStatus: Bool = false, isDeferInit: Bool = false, dropInViewStyleManager: DropInViewStyleManager? = nil, successfulPaymentCompletion: @escaping () -> Void) -> UIViewController {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        let typeDescriptionsSwift = objcTypes.map { TypeDescription(rawValue: $0.value)! }
        return self.dropInViewController(jwt: jwt, typeDescriptions: typeDescriptionsSwift, gatewayType: gatewayType, username: username, isLiveStatus: isLiveStatus, isDeferInit: isDeferInit, dropInViewStyleManager: dropInViewStyleManager, successfulPaymentCompletion: successfulPaymentCompletion)
    }
}
