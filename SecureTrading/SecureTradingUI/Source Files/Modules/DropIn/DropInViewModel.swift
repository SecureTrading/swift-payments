//
//  DropInViewModel.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTrading3DSecure
import SecureTradingCard
import SecureTradingCore
#endif
import Foundation

final class DropInViewModel {
    // MARK: Properties

    private let jwt: String

    /// - SeeAlso: SecureTradingCore.APIManager
    private let apiManager: APIManager

    /// - SeeAlso: SecureTrading3DSecure.ST3DSecureManager
    private let threeDSecureManager: ST3DSecureManager

    private let typeDescriptions: [TypeDescription]

    private let isLiveStatus: Bool

    private let isDeferInit: Bool

    private var isJsInitCompleted: Bool = false

    private var jsInitError: String?

    private var jsInitCacheToken: String?

    private var shouldStartTransactionAfterJsInit: Bool = false

    private var card: Card?

    var isSaveCardEnabled: Bool = true
    var showTransactionSuccess: ((ResponseSettleStatus, STCardReference?) -> Void)?
    var showTransactionError: ((String) -> Void)?
    var showValidationError: ((ResponseErrorDetail) -> Void)?
    var cardinalWarningsCompletion: ((String, [CardinalInitWarnings]) -> Void)?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiManager: API manager
    /// - Parameter jwt: jwt token
    /// - Parameter typeDescriptions: request types (AUTH, THREEDQUERY...)
    /// - Parameter gatewayType: gateway type (us or european)
    /// - Parameter username: merchant's username
    /// - Parameter isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment)
    /// - Parameter isDeferInit: It says when the connection with sdk Cardinal Commerce is initiated, whether at the beginning or only after accepting the form (true value)
    init(jwt: String, typeDescriptions: [TypeDescription], gatewayType: GatewayType, username: String, isLiveStatus: Bool, isDeferInit: Bool) {
        self.jwt = jwt
        self.typeDescriptions = typeDescriptions
        self.apiManager = DefaultAPIManager(gatewayType: gatewayType, username: username)
        self.isLiveStatus = isLiveStatus
        self.isDeferInit = isDeferInit
        self.threeDSecureManager = ST3DSecureManager(isLiveStatus: self.isLiveStatus)

        if !isDeferInit {
            self.makeJSInitRequest(completion: { [weak self] _ in
                guard let self = self else { return }
                self.isJsInitCompleted = true
                if let card = self.card, self.shouldStartTransactionAfterJsInit {
                    self.shouldStartTransactionAfterJsInit = false
                    self.makeRequest(cardNumber: card.cardNumber, securityCode: card.securityCode, expiryDate: card.expiryDate)
                }
            }, failure: { [weak self] errorMessage in
                guard let self = self else { return }
                self.isJsInitCompleted = true
                self.jsInitError = errorMessage
            })
        }
    }

    // MARK: Api requests

    /// executes payment transaction request
    /// - Parameters:
    ///   - cardNumber: The long number printed on the front of the customer’s card.
    ///   - securityCode: The three digit security code printed on the back of the card. (For AMEX cards, this is a 4 digit code found on the front of the card), This field is not strictly required.
    ///   - expiryDate: The expiry date printed on the card.
    private func makeRequest(cardNumber: CardNumber, securityCode: CVC?, expiryDate: ExpiryDate) {
        let authRequest = RequestObject(typeDescriptions: self.typeDescriptions, cardNumber: cardNumber.rawValue, securityCode: securityCode?.rawValue, expiryDate: expiryDate.rawValue)

        self.apiManager.makeGeneralRequest(jwt: self.jwt, request: authRequest, success: { [weak self] responseObject, _ in
            guard let self = self else { return }
            switch responseObject.responseErrorCode {
            case .successful:
                self.showTransactionSuccess?(responseObject.responseSettleStatus, self.isSaveCardEnabled ? responseObject.cardReference : nil )
            default:
                self.showTransactionError?(responseObject.errorMessage)
            }
        }, failure: { [weak self] error in
            guard let self = self else { return }
            switch error {
            case .responseValidationError(let responseError):
                switch responseError {
                case .invalidField(let errorCode):
                    switch errorCode {
                    case .invalidPAN, .invalidSecurityCode, .invalidExpiryDate:
                        self.showValidationError?(errorCode)
                    default: self.showTransactionError?(error.humanReadableDescription)
                    }

                default:
                    self.showTransactionError?(error.humanReadableDescription)
                }
            default:
                self.showTransactionError?(error.humanReadableDescription)
            }
        })
    }

    /// executes js init request (to get threeDInit - JWT token to setup the Cardinal) and Cardinal setup
    /// - Parameter completion: success closure with following parameters: consumer session id
    /// - Parameter failure: closure with error message
    private func makeJSInitRequest(completion: @escaping ((String) -> Void), failure: @escaping ((String) -> Void)) {
        let jsInitRequest = RequestObject(typeDescriptions: [.jsInit])

        self.apiManager.makeGeneralRequest(jwt: self.jwt, request: jsInitRequest, success: { [weak self] responseObject, _ in
            guard let self = self else { return }
            switch responseObject.responseErrorCode {
            case .successful:
                self.jsInitCacheToken = responseObject.cacheToken!
                self.threeDSecureManager.setup(with: responseObject.threeDInit!, completion: { consumerSessionId in
                    completion(consumerSessionId)
                }, failure: { validateResponse in
                    failure(validateResponse.errorDescription)
                })
            default:
                failure(responseObject.errorMessage)
            }
        }, failure: { error in
            failure(error.humanReadableDescription)
        })
    }

    // MARK: Transaction flow

    /// executes payment transaction flow
    /// - Parameters:
    ///   - cardNumber: The long number printed on the front of the customer’s card.
    ///   - securityCode: The three digit security code printed on the back of the card. (For AMEX cards, this is a 4 digit code found on the front of the card), This field is not strictly required.
    ///   - expiryDate: The expiry date printed on the card.
    func performTransaction(cardNumber: CardNumber, securityCode: CVC?, expiryDate: ExpiryDate) {
        self.card = Card(cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)

        if !self.isDeferInit {
            guard self.isJsInitCompleted else {
                self.shouldStartTransactionAfterJsInit = true
                return
            }

            guard let jsInitError = jsInitError else {
                self.makeRequest(cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)
                return
            }

            self.showTransactionError?(jsInitError)
        } else {
            self.makeJSInitRequest(completion: { [weak self] _ in
                guard let self = self else { return }
                self.makeRequest(cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)
            }, failure: { [weak self] errorMessage in
                guard let self = self else { return }
                self.showTransactionError?(errorMessage)
            })
        }
    }

    // MARK: Validation

    func handleCardinalWarnings() {
        let warnings = threeDSecureManager.warnings
        guard !warnings.isEmpty else { return }
        let warningsErrorMessage = warnings.map({ $0.localizedDescription }).joined(separator: ", ")
        cardinalWarningsCompletion?(warningsErrorMessage, warnings)
    }

    /// Validates all input views in form
    /// - Parameter view: form view
    /// - Returns: result of validation
    @discardableResult
    func validateForm(view: DropInView) -> Bool {
        let cardNumberValidationResult = view.cardNumberInput.validate(silent: false)
        let expiryDateValidationResult = view.expiryDateInput.validate(silent: false)
        let cvcValidationResult = view.cvcInput.validate(silent: false)
        return cardNumberValidationResult && expiryDateValidationResult && cvcValidationResult
    }
}
