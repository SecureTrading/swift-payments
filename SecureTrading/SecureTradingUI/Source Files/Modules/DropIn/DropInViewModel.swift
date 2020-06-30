//
//  DropInViewModel.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCore
import SecureTrading3DSecure
import SecureTradingCard
#endif
import Foundation

final class DropInViewModel {
    // MARK: Properties

    private var paymentTransactionManager: PaymentTransactionManager

    private var jwt: String

    private let typeDescriptions: [TypeDescription]

    var transactionSuccessClosure: ((JWTResponseObject, STCardReference?) -> Void)?
    var transactionErrorClosure: ((JWTResponseObject?, String) -> Void)?
    var cardinalAuthenticationErrorClosure: (() -> Void)?
    var validationErrorClosure: ((String, ResponseErrorDetail) -> Void)?
    var cardinalWarningsCompletion: ((String, [CardinalInitWarnings]) -> Void)?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter jwt: jwt token
    /// - Parameter typeDescriptions: request types (AUTH, THREEDQUERY...)
    /// - Parameter gatewayType: gateway type (us or european)
    /// - Parameter username: merchant's username
    /// - Parameter isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment)
    /// - Parameter isDeferInit: It says when the connection with sdk Cardinal Commerce is initiated, whether at the beginning or only after accepting the form (true value)
    /// - Parameter cardTypeToBypass: the collection of cards for which 3dsecure is to be bypassed
    /// - Parameter cardinalStyleManager: manager to set the interface style (view customization)
    init(jwt: String, typeDescriptions: [TypeDescription], gatewayType: GatewayType, username: String, isLiveStatus: Bool, isDeferInit: Bool, cardTypeToBypass: [CardType], cardinalStyleManager: CardinalStyleManager?) {
        self.jwt = jwt
        self.typeDescriptions = typeDescriptions

        self.paymentTransactionManager = PaymentTransactionManager(jwt: jwt, gatewayType: gatewayType, username: username, isLiveStatus: isLiveStatus, isDeferInit: isDeferInit, cardTypeToBypass: cardTypeToBypass, cardinalStyleManager: cardinalStyleManager)
    }

    /// executes payment transaction flow
    /// - Parameters:
    ///   - cardNumber: The long number printed on the front of the customer’s card.
    ///   - securityCode: The three digit security code printed on the back of the card. (For AMEX cards, this is a 4 digit code found on the front of the card), This field is not strictly required.
    ///   - expiryDate: The expiry date printed on the card.
    func performTransaction(cardNumber: CardNumber, securityCode: CVC?, expiryDate: ExpiryDate) {
        let card = Card(cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)
        // swiftlint:disable line_length
        paymentTransactionManager.performTransaction(jwt: jwt, typeDescriptions: typeDescriptions, card: card, transactionSuccessClosure: transactionSuccessClosure, transactionErrorClosure: transactionErrorClosure, cardinalAuthenticationErrorClosure: cardinalAuthenticationErrorClosure, validationErrorClosure: validationErrorClosure)
        // swiftlint:enable line_length
    }

    func handleCardinalWarnings() {
        paymentTransactionManager.handleCardinalWarnings(cardinalWarningsCompletion: cardinalWarningsCompletion)
    }

    /// Validates all input views in form
    /// - Parameter view: form view
    /// - Returns: result of validation
    @discardableResult
    func validateForm(view: DropInViewProtocol) -> Bool {
        // validate only fields that are added to the view's hierarchy
        let viewsToValidate = [view.cardNumberInput, view.expiryDateInput, view.cvcInput].filter { ($0 as? BaseView)?.hasSuperview == true }
        return viewsToValidate.count == viewsToValidate.filter { $0.validate(silent: false) }.count && view.isFormValid
    }

    // MARK: Helpers

    /// Updates JWT token
    /// - Parameter newValue: updated JWT token
    func updateJWT(newValue: String) {
        jwt = newValue
    }
}
