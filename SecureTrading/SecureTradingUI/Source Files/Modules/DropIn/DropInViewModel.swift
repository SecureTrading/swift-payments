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

    private var jwt: String

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

    private let requestId: String

    private let termUrl = "https://termurl.com"

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
        let randomString = String.randomString(length: 36)
        let start = randomString.index(randomString.startIndex, offsetBy: 2)
        let end = randomString.index(randomString.startIndex, offsetBy: 10)
        let range = start..<end
        self.requestId = "J-" + randomString[range]

        if !isDeferInit {
            self.makeJSInitRequest(completion: { [weak self] _ in
                guard let self = self else { return }
                self.isJsInitCompleted = true
                if let card = self.card, self.shouldStartTransactionAfterJsInit {
                    self.shouldStartTransactionAfterJsInit = false
                    self.makePaymentOrThreeDQueryRequest(cardNumber: card.cardNumber, securityCode: card.securityCode, expiryDate: card.expiryDate)
                }
            }, failure: { [weak self] errorMessage in
                guard let self = self else { return }
                self.isJsInitCompleted = true
                self.jsInitError = errorMessage
                if self.shouldStartTransactionAfterJsInit {
                    self.shouldStartTransactionAfterJsInit = false
                    self.showTransactionError?(errorMessage)
                }
            })
        }
    }

    // MARK: Api requests

    /// executes payment transaction request
    /// - Parameters:
    ///   - request: RequestObject instance
    ///   - success: success closure
    ///   - transactionError: failure closure (general error)
    ///   - validationError: failure closure (card validation error)
    func makePaymentRequest(request: RequestObject, success: @escaping ((JWTResponseObject) -> Void), transactionError: @escaping ((String) -> Void), validationError: @escaping ((ResponseErrorDetail) -> Void)) {
        self.apiManager.makeGeneralRequest(jwt: self.jwt, request: request, success: { responseObject, _ in
            switch responseObject.responseErrorCode {
            case .successful:
                success(responseObject)
            default:
                transactionError(responseObject.errorMessage)
            }
        }, failure: { error in
            switch error {
            case .responseValidationError(let responseError):
                switch responseError {
                case .invalidField(let errorCode):
                    switch errorCode {
                    case .invalidPAN, .invalidSecurityCode, .invalidExpiryDate:
                        validationError(errorCode)
                    default: transactionError(error.humanReadableDescription)
                    }

                default:
                    transactionError(error.humanReadableDescription)
                }
            default:
                transactionError(error.humanReadableDescription)
            }
        })
    }

    /// executes payment transaction or threedquery request
    /// - Parameters:
    ///   - cardNumber: The long number printed on the front of the customer’s card.
    ///   - securityCode: The three digit security code printed on the back of the card. (For AMEX cards, this is a 4 digit code found on the front of the card), This field is not strictly required.
    ///   - expiryDate: The expiry date printed on the card.
    private func makePaymentOrThreeDQueryRequest(cardNumber: CardNumber, securityCode: CVC?, expiryDate: ExpiryDate) {
        let termUrl = self.typeDescriptions.contains(.threeDQuery) ? self.termUrl : nil
        let tempTypeDescriptions = self.typeDescriptions.contains(.threeDQuery) ? [.threeDQuery] : self.typeDescriptions
        let request = RequestObject(typeDescriptions: tempTypeDescriptions, requestId: self.requestId, cardNumber: cardNumber.rawValue, securityCode: securityCode?.rawValue, expiryDate: expiryDate.rawValue, termUrl: termUrl, cacheToken: self.jsInitCacheToken)

        self.makePaymentRequest(request: request, success: { [weak self] responseObject in
            guard let self = self else { return }
            guard tempTypeDescriptions.contains(.threeDQuery) else {
                self.showTransactionSuccess?(responseObject.responseSettleStatus, self.isSaveCardEnabled ? responseObject.cardReference : nil)
                return
            }
            self.handleThreeDSecureFlow(responseObject: responseObject)
        }, transactionError: { [weak self] error in
            guard let self = self else { return }
            self.showTransactionError?(error)
        }, validationError: { [weak self] errorCode in
            guard let self = self else { return }
            self.showValidationError?(errorCode)
        })
    }

    /// executes js init request (to get threeDInit - JWT token to setup the Cardinal) and Cardinal setup
    /// - Parameter completion: success closure with following parameters: consumer session id
    /// - Parameter failure: closure with error message
    private func makeJSInitRequest(completion: @escaping ((String) -> Void), failure: @escaping ((String) -> Void)) {
        let jsInitRequest = RequestObject(typeDescriptions: [.jsInit], requestId: self.requestId)

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
                self.makePaymentOrThreeDQueryRequest(cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)
                return
            }

            self.showTransactionError?(jsInitError)
        } else {
            self.makeJSInitRequest(completion: { [weak self] _ in
                guard let self = self else { return }
                self.makePaymentOrThreeDQueryRequest(cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)
            }, failure: { [weak self] errorMessage in
                guard let self = self else { return }
                self.showTransactionError?(errorMessage)
            })
        }
    }

    // MARK: 3DSecure flow

    /// Checking if it is possible to perform a 3dsecure check (Cardinal Authentication)
    /// - Parameter responseObject: response object from threedquery request
    private func handleThreeDSecureFlow(responseObject: JWTResponseObject) {
        // bypass 3dsecure
        guard let cardEnrolled = responseObject.cardEnrolled, responseObject.acsUrl != nil, cardEnrolled == "Y" else {
            let tempTypeDescription = self.typeDescriptions.filter { $0 != .threeDQuery }
            let request = RequestObject(typeDescriptions: tempTypeDescription, requestId: self.requestId, cardNumber: self.card?.cardNumber.rawValue, securityCode: self.card?.securityCode?.rawValue, expiryDate: self.card?.expiryDate.rawValue, cacheToken: self.jsInitCacheToken)

            self.makePaymentRequest(request: request, success: { [weak self] responseObject in
                guard let self = self else { return }
                self.showTransactionSuccess?(responseObject.responseSettleStatus, self.isSaveCardEnabled ? responseObject.cardReference : nil)
            }, transactionError: { [weak self] error in
                guard let self = self else { return }
                self.showTransactionError?(error)
            }, validationError: { [weak self] errorCode in
                guard let self = self else { return }
                self.showValidationError?(errorCode)
            })

            return
        }

        self.createAuthenticationSessionWithCardinal(transactionId: responseObject.acquirerTransactionReference!, transactionPayload: responseObject.threeDPayload ?? .empty)
    }

    /// Create the authentication session - call this method to hand control to SDK for performing the challenge between the user and the issuing bank.
    /// - Parameters:
    ///   - transactionId: acquirerTransactionReference property from threedquery response
    ///   - transactionPayload: threeDPayload property from threedquery response
    private func createAuthenticationSessionWithCardinal(transactionId: String, transactionPayload: String) {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "3dsecure-flow")
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        var jwtForValidation: String?
        var jwtResponseObject: JWTResponseObject?
        var transactionError: String?
        var validationError: ResponseErrorDetail?

        dispatchQueue.async {
            dispatchGroup.enter()
            self.threeDSecureManager.continueSession(with: transactionId, payload: transactionPayload, sessionAuthenticationValidateJWT: { jwt in
                jwtForValidation = jwt
                dispatchSemaphore.signal()
                dispatchGroup.leave()
            }, sessionAuthenticationFailure: {
                // todo error message
                transactionError = "authentication error"
                dispatchSemaphore.signal()
                dispatchGroup.leave()
            })

            dispatchSemaphore.wait()
            guard let jwtForValidation = jwtForValidation else { return }
            dispatchGroup.enter()

            let tempTypeDescription = self.typeDescriptions.filter { $0 != .threeDQuery }
            // swiftlint:disable line_length
            let request = RequestObject(typeDescriptions: tempTypeDescription, requestId: self.requestId, cardNumber: self.card?.cardNumber.rawValue, securityCode: self.card?.securityCode?.rawValue, expiryDate: self.card?.expiryDate.rawValue, threeDResponse: jwtForValidation, cacheToken: self.jsInitCacheToken)
            // swiftlint:enable line_length

            self.makePaymentRequest(request: request, success: { responseObject in
                jwtResponseObject = responseObject
                dispatchSemaphore.signal()
                dispatchGroup.leave()
            }, transactionError: { error in
                transactionError = error
                dispatchSemaphore.signal()
                dispatchGroup.leave()
            }, validationError: { errorCode in
                validationError = errorCode
                dispatchSemaphore.signal()
                dispatchGroup.leave()
            })

            dispatchSemaphore.wait()
        }

        dispatchGroup.notify(queue: dispatchQueue) {
            DispatchQueue.main.async {
                if let error = transactionError {
                    self.showTransactionError?(error)
                    return
                }

                if let errorCode = validationError {
                    self.showValidationError?(errorCode)
                    return
                }

                self.showTransactionSuccess?(jwtResponseObject!.responseSettleStatus, self.isSaveCardEnabled ? jwtResponseObject!.cardReference : nil)
            }
        }
    }

    // MARK: Validation

    func handleCardinalWarnings() {
        let warnings = self.threeDSecureManager.warnings
        guard !warnings.isEmpty else { return }
        let warningsErrorMessage = warnings.map { $0.localizedDescription }.joined(separator: ", ")
        self.cardinalWarningsCompletion?(warningsErrorMessage, warnings)
    }

    /// Validates all input views in form
    /// - Parameter view: form view
    /// - Returns: result of validation
    @discardableResult
    func validateForm(view: DropInViewProtocol) -> Bool {
        let cardNumberValidationResult = view.cardNumberInput.validate(silent: false)
        let expiryDateValidationResult = view.expiryDateInput.validate(silent: false)
        let cvcValidationResult = view.cvcInput.validate(silent: false)
        return cardNumberValidationResult && expiryDateValidationResult && cvcValidationResult
    }

    // MARK: Helpers

    /// Updates JWT token
    /// - Parameter newValue: updated JWT token
    func updateJWT(newValue: String) {
        self.jwt = newValue
    }
}
