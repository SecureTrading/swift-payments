//
//  ViewControllerFactory.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTrading3DSecure
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
    ///   - typeDescriptions: request types (default: THREEDQUERY, AUTH )
    ///   - gatewayType: gateway type (us or european)
    ///   - username: merchant's username
    ///   - successfulPaymentCompletion: Closure triggered by pressing the button in the successful payment alert
    ///   - dropInViewStyleManager: instance of manager to customize view
    ///   - isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment - default behaviour)
    ///   - isDeferInit: It says when the connection with sdk Cardinal Commerce is initiated, whether at the beginning or only after accepting the form (true value)
    ///   - cardinalWarningsCompletion: Closure triggered when warnings are detected by the Cardinal (e.g. is the device jailbroken)
    ///   - transactionFailure: Closure triggered by pressing the button in the failure payment alert
    /// - Returns: instance of DropInViewController
    public func dropInViewController(jwt: String, typeDescriptions: [TypeDescription] = [.threeDQuery, .auth], gatewayType: GatewayType, username: String, isLiveStatus: Bool = false, isDeferInit: Bool = false, dropInViewStyleManager: DropInViewStyleManager? = nil, successfulPaymentCompletion: @escaping (ResponseSettleStatus, STCardReference?) -> Void, transactionFailure: @escaping () -> Void, cardinalWarningsCompletion: ((String, [CardinalInitWarnings]) -> Void)? = nil) -> DropInController {
        // swiftlint:disable line_length
        let viewController = DropInViewController(view: DropInView(dropInViewStyleManager: dropInViewStyleManager), viewModel: DropInViewModel(jwt: jwt, typeDescriptions: typeDescriptions, gatewayType: gatewayType, username: username, isLiveStatus: isLiveStatus, isDeferInit: isDeferInit))
        // swiftlint:enable line_length

        viewController.eventTriggered = { event in
            switch event {
            case .successfulPayment(let responseSettleStatus):
                successfulPaymentCompletion(responseSettleStatus, nil)
            case .successfulPaymentCardAdded(let responseSettleStatus, let cardReferece):
                successfulPaymentCompletion(responseSettleStatus, cardReferece)
            case .cardinalWarnings(let warningsMessage, let warnings):
                cardinalWarningsCompletion?(warningsMessage, warnings)
            case .transactionFailure:
                transactionFailure()
            }
        }
        return viewController
    }

    /// creates instances of the AddCardViewController
    /// - Parameters:
    ///   - jwt: jwt: jwt token
    ///   - typeDescriptions: request types (AUTH, THREEDQUERY...)
    ///   - gatewayType: gateway type (us or european)
    ///   - username: merchant's username
    ///   - cardAddedCompletion: Closure triggered by pressing the button in the card added alert
    ///   - dropInViewStyleManager: instance of manager to customize view
    /// - Returns: instance of DropInViewController
    public func addCardViewController(jwt: String, typeDescriptions: [TypeDescription], gatewayType: GatewayType, username: String, dropInViewStyleManager: DropInViewStyleManager? = nil, cardAddedCompletion: @escaping (STCardReference?) -> Void) -> UIViewController {
        let viewController = AddCardViewController(view: AddCardView(dropInViewStyleManager: dropInViewStyleManager), viewModel: AddCardViewModel(jwt: jwt, typeDescriptions: typeDescriptions, gatewayType: gatewayType, username: username))
        viewController.eventTriggered = { event in
            switch event {
            case .added(let cardReference):
                cardAddedCompletion(cardReference)
            }
        }
        return viewController
    }

    // MARK: Objective C accessible methods

    // objc workaround
    /// creates instances of the DropInViewController
    /// - Parameters:
    ///   - jwt: jwt: jwt token
    ///   - typeDescriptions: request types (default: THREEDQUERY, AUTH )
    ///   - gatewayType: gateway type (us or european)
    ///   - username: merchant's username
    ///   - successfulPaymentCompletion: Closure triggered by pressing the button in the successful payment alert
    ///   - dropInViewStyleManager: instance of manager to customize view
    ///   - isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment - default behaviour)
    ///   - isDeferInit: It says when the connection with sdk Cardinal Commerce is initiated, whether at the beginning or only after accepting the form (true value)
    ///   - cardinalWarningsCompletion: Closure triggered when warnings are detected by the Cardinal (e.g. is the device jailbroken)
    /// - Returns: instance of DropInViewController
    @objc public func dropInViewController(jwt: String, typeDescriptions: [Int] = [1, 0], gatewayType: GatewayType, username: String, isLiveStatus: Bool = false, isDeferInit: Bool = false, dropInViewStyleManager: DropInViewStyleManager? = nil, successfulPaymentCompletion: @escaping (ResponseSettleStatus, STCardReference?) -> Void, transactionFailure: @escaping () -> Void, cardinalWarningsCompletion: ((String, [Int]) -> Void)? = nil) -> DropInController {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        let typeDescriptionsSwift = objcTypes.map { TypeDescription(rawValue: $0.value)! }

        // swiftlint:disable line_length
        return self.dropInViewController(jwt: jwt, typeDescriptions: typeDescriptionsSwift, gatewayType: gatewayType, username: username, isLiveStatus: isLiveStatus, isDeferInit: isDeferInit, dropInViewStyleManager: dropInViewStyleManager, successfulPaymentCompletion: successfulPaymentCompletion, transactionFailure: transactionFailure, cardinalWarningsCompletion: { warningsMessage, warnings in
            cardinalWarningsCompletion?(warningsMessage, warnings.map { $0.rawValue })
        })
        // swiftlint:enable line_length
    }

    // objc workaround
    /// creates instances of the DropInViewController
    /// - Parameters:
    ///   - jwt: jwt: jwt token
    ///   - typeDescriptions: request types (AUTH, THREEDQUERY...)
    ///   - gatewayType: gateway type (us or european)
    ///   - username: merchant's username
    ///   - cardAddedCompletion: Closure triggered by pressing the button in the successful payment alert
    ///   - dropInViewStyleManager: instance of manager to customize view
    /// - Returns: instance of DropInViewController
    @objc public func addCardViewController(jwt: String, typeDescriptions: [Int], gatewayType: GatewayType, username: String, dropInViewStyleManager: DropInViewStyleManager? = nil, cardAddedCompletion: @escaping (STCardReference?) -> Void) -> UIViewController {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        let typeDescriptionsSwift = objcTypes.map { TypeDescription(rawValue: $0.value)! }
        return self.addCardViewController(jwt: jwt, typeDescriptions: typeDescriptionsSwift, gatewayType: gatewayType, username: username, dropInViewStyleManager: dropInViewStyleManager, cardAddedCompletion: cardAddedCompletion)
    }
}
