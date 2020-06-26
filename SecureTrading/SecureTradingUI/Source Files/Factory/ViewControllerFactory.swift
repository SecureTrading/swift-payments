//
//  ViewControllerFactory.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTrading3DSecure
import SecureTradingCard
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
    ///   - successfulPaymentCompletion: Closure triggered after a successful payment transaction
    ///   - dropInViewStyleManager: instance of manager to customize view
    ///   - cardTypeToBypass: the collection of cards for which 3dsecure is to be bypassed
    ///   - isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment - default behaviour)
    ///   - isDeferInit: It says when the connection with sdk Cardinal Commerce is initiated, whether at the beginning or only after accepting the form (true value - should be true when you want to update the JWT token at this point)
    ///   - cardinalWarningsCompletion: Closure triggered at the stage of showing the form when warnings are detected by the Cardinal (e.g. is the device jailbroken)
    ///   - transactionFailure: Closure triggered after a failed transaction, when a error was returned at some stage
    ///   - customDropInView: DropInViewProtocol compliant view (for example, to add some additional fields such as address, tip)
    ///   - payButtonTappedClosureBeforeTransaction: Closure triggered by pressing the pay button (just before the transaction - you can use this closure to update the JWT token)
    /// - Returns: instance of DropInViewController
    public func dropInViewController(jwt: String, typeDescriptions: [TypeDescription] = [.threeDQuery, .auth], gatewayType: GatewayType, username: String, isLiveStatus: Bool = false, isDeferInit: Bool = false, customDropInView: DropInViewProtocol? = nil, dropInViewStyleManager: DropInViewStyleManager? = nil, cardTypeToBypass: [CardType] = [], payButtonTappedClosureBeforeTransaction: @escaping (DropInController) -> Void, successfulPaymentCompletion: @escaping (JWTResponseObject, String, STCardReference?) -> Void, transactionFailure: @escaping (JWTResponseObject?, String) -> Void, cardinalWarningsCompletion: ((String, [CardinalInitWarnings]) -> Void)? = nil) -> DropInController {
        let dropInView = customDropInView ?? DropInView(dropInViewStyleManager: dropInViewStyleManager)

        let viewController = DropInViewController(view: dropInView, viewModel: DropInViewModel(jwt: jwt, typeDescriptions: typeDescriptions, gatewayType: gatewayType, username: username, isLiveStatus: isLiveStatus, isDeferInit: isDeferInit, cardTypeToBypass: cardTypeToBypass))

        viewController.eventTriggered = { event in
            switch event {
            case .successfulPayment(let responseObject, let successMessage):
                successfulPaymentCompletion(responseObject, successMessage, nil)
            case .successfulPaymentCardAdded(let responseObject, let successMessage, let cardReferece):
                successfulPaymentCompletion(responseObject, successMessage, cardReferece)
            case .cardinalWarnings(let warningsMessage, let warnings):
                cardinalWarningsCompletion?(warningsMessage, warnings)
            case .transactionFailure(let responseObject, let errorMessage):
                transactionFailure(responseObject, errorMessage)
            case .payButtonTappedClosureBeforeTransaction(let controller):
                payButtonTappedClosureBeforeTransaction(controller)
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
    ///   - successfulPaymentCompletion: Closure triggered after a successful payment transaction
    ///   - dropInViewStyleManager: instance of manager to customize view
    ///   - cardTypeToBypass: the collection of cards for which 3dsecure is to be bypassed
    ///   - isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment - default behaviour)
    ///   - isDeferInit: It says when the connection with sdk Cardinal Commerce is initiated, whether at the beginning or only after accepting the form (true value - should be true when you want to update the JWT token at this point)
    ///   - cardinalWarningsCompletion: Closure triggered at the stage of showing the form when warnings are detected by the Cardinal (e.g. is the device jailbroken)
    ///   - transactionFailure: Closure triggered after a failed transaction, when a error was returned at some stage
    ///   - customDropInView: DropInViewProtocol compliant view (for example, to add some additional fields such as address, tip)
    ///   - payButtonTappedClosureBeforeTransaction: Closure triggered by pressing the pay button (just before the transaction - you can use this closure to update the JWT token)
    /// - Returns: instance of DropInViewController
    @objc public func dropInViewController(jwt: String, typeDescriptions: [Int] = [1, 0], gatewayType: GatewayType, username: String, isLiveStatus: Bool = false, isDeferInit: Bool = false, customDropInView: DropInViewProtocol? = nil, dropInViewStyleManager: DropInViewStyleManager? = nil, cardTypeToBypass: [Int] = [], payButtonTappedClosureBeforeTransaction: @escaping (DropInController) -> Void, successfulPaymentCompletion: @escaping (JWTResponseObject, String, STCardReference?) -> Void, transactionFailure: @escaping (JWTResponseObject?, String) -> Void, cardinalWarningsCompletion: ((String, [Int]) -> Void)? = nil) -> DropInController {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        let typeDescriptionsSwift = objcTypes.map { TypeDescription(rawValue: $0.value)! }

        let cardTypesSwift = cardTypeToBypass.map { CardType(rawValue: $0)! }

        // swiftlint:disable line_length
        return self.dropInViewController(jwt: jwt, typeDescriptions: typeDescriptionsSwift, gatewayType: gatewayType, username: username, isLiveStatus: isLiveStatus, isDeferInit: isDeferInit, customDropInView: customDropInView, dropInViewStyleManager: dropInViewStyleManager, cardTypeToBypass: cardTypesSwift, payButtonTappedClosureBeforeTransaction: payButtonTappedClosureBeforeTransaction, successfulPaymentCompletion: successfulPaymentCompletion, transactionFailure: transactionFailure, cardinalWarningsCompletion: { warningsMessage, warnings in

            cardinalWarningsCompletion?(warningsMessage, warnings.map { $0.rawValue })
        })
        // swiftlint:enable line_length
    }
}
