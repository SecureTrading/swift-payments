//
//  PaymentTransactionManager.swift
//  SecureTradingCore
//

#if !COCOAPODS
import SecureTrading3DSecure
#endif
import Foundation

@objc public final class PaymentTransactionManager: NSObject {
    // MARK: Properties

    private var jwt: String

    private var typeDescriptions: [TypeDescription] = []

    /// - SeeAlso: SecureTradingCore.APIManager
    private let apiManager: APIManager

    /// - SeeAlso: SecureTrading3DSecure.ST3DSecureManager
    private let threeDSecureManager: ST3DSecureManager

    private let isLiveStatus: Bool

    private let isDeferInit: Bool

    private var isJsInitCompleted: Bool = false

    private var jsInitError: (JWTResponseObject?, String?)

    private var jsInitCacheToken: String?

    private var shouldStartTransactionAfterJsInit: Bool = false

    private var card: Card?

    private let requestId: String

    private let termUrl = "https://termurl.com"

    private var transactionSuccessClosure: ((JWTResponseObject, STCardReference?) -> Void)?
    private var transactionErrorClosure: ((JWTResponseObject?, String) -> Void)?
    private var cardinalAuthenticationErrorClosure: (() -> Void)?
    private var validationErrorClosure: ((ResponseErrorDetail) -> Void)?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter jwt: jwt token
    /// - Parameter gatewayType: gateway type (us or european)
    /// - Parameter username: merchant's username
    /// - Parameter isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment)
    /// - Parameter isDeferInit: It says when the connection with sdk Cardinal Commerce is initiated, whether at the beginning or only after accepting the form (true value)
    @objc public init(jwt: String, gatewayType: GatewayType, username: String, isLiveStatus: Bool, isDeferInit: Bool) {
        self.jwt = jwt
        self.apiManager = DefaultAPIManager(gatewayType: gatewayType, username: username)
        self.isLiveStatus = isLiveStatus
        self.isDeferInit = isDeferInit
        self.threeDSecureManager = ST3DSecureManager(isLiveStatus: self.isLiveStatus)
        let randomString = String.randomString(length: 36)
        let start = randomString.index(randomString.startIndex, offsetBy: 2)
        let end = randomString.index(randomString.startIndex, offsetBy: 10)
        let range = start..<end
        self.requestId = "J-" + randomString[range]
        super.init()

        if !isDeferInit {
            self.makeJSInitRequest(completion: { [weak self] _ in
                guard let self = self else { return }
                self.isJsInitCompleted = true
                if self.shouldStartTransactionAfterJsInit {
                    self.shouldStartTransactionAfterJsInit = false
                    self.makePaymentOrThreeDQueryRequest()
                }
            }, failure: { [weak self] responseObject, errorMessage in
                guard let self = self else { return }
                self.isJsInitCompleted = true
                self.jsInitError = (responseObject, errorMessage)
                if self.shouldStartTransactionAfterJsInit {
                    self.shouldStartTransactionAfterJsInit = false
                    self.transactionErrorClosure?(responseObject, errorMessage)
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
    private func makePaymentRequest(request: RequestObject, success: @escaping ((JWTResponseObject) -> Void), transactionError: @escaping ((JWTResponseObject?, String) -> Void), validationError: @escaping ((ResponseErrorDetail) -> Void)) {
        self.apiManager.makeGeneralRequest(jwt: self.jwt, request: request, success: { responseObject, _, newJWT in
            self.jwt = newJWT
            switch responseObject.responseErrorCode {
            case .successful:
                success(responseObject)
            default:
                transactionError(responseObject, responseObject.errorMessage)
            }
        }, failure: { error in
            switch error {
            case .responseValidationError(let responseError):
                switch responseError {
                case .invalidField(let errorCode):
                    switch errorCode {
                    case .invalidPAN, .invalidSecurityCode, .invalidExpiryDate:
                        validationError(errorCode)
                    default: transactionError(nil, error.humanReadableDescription)
                    }

                default:
                    transactionError(nil, error.humanReadableDescription)
                }
            default:
                transactionError(nil, error.humanReadableDescription)
            }
        })
    }

    /// executes payment transaction or threedquery request
    private func makePaymentOrThreeDQueryRequest() {
        let termUrl = self.typeDescriptions.contains(.threeDQuery) ? self.termUrl : nil
        let tempTypeDescriptions = self.typeDescriptions.contains(.threeDQuery) ? [.threeDQuery] : self.typeDescriptions
        let request = RequestObject(typeDescriptions: tempTypeDescriptions, requestId: self.requestId, cardNumber: self.card?.cardNumber.rawValue, securityCode: self.card?.securityCode?.rawValue, expiryDate: self.card?.expiryDate.rawValue, termUrl: termUrl, cacheToken: self.jsInitCacheToken)

        self.makePaymentRequest(request: request, success: { [weak self] responseObject in
            guard let self = self else { return }
            guard tempTypeDescriptions.contains(.threeDQuery) else {
                self.transactionSuccessClosure?(responseObject, responseObject.cardReference)
                return
            }
            self.handleThreeDSecureFlow(responseObject: responseObject)
        }, transactionError: { [weak self] responseObject, error in
            guard let self = self else { return }
            self.transactionErrorClosure?(responseObject, error)
        }, validationError: { [weak self] errorCode in
            guard let self = self else { return }
            self.validationErrorClosure?(errorCode)
        })
    }

    /// executes js init request (to get threeDInit - JWT token to setup the Cardinal) and Cardinal setup
    /// - Parameter completion: success closure with following parameters: consumer session id
    /// - Parameter failure: closure with error message
    private func makeJSInitRequest(completion: @escaping ((String) -> Void), failure: @escaping ((JWTResponseObject?, String) -> Void)) {
        let jsInitRequest = RequestObject(typeDescriptions: [.jsInit], requestId: self.requestId)

        self.apiManager.makeGeneralRequest(jwt: self.jwt, request: jsInitRequest, success: { [weak self] responseObject, _, newJWT in
            guard let self = self else { return }
            self.jwt = newJWT
            switch responseObject.responseErrorCode {
            case .successful:
                self.jsInitCacheToken = responseObject.cacheToken!
                self.threeDSecureManager.setup(with: responseObject.threeDInit!, completion: { consumerSessionId in
                    completion(consumerSessionId)
                }, failure: { validateResponse in
                    failure(nil, validateResponse.errorDescription)
                })
            default:
                failure(responseObject, responseObject.errorMessage)
            }
        }, failure: { error in
            failure(nil, error.humanReadableDescription)
        })
    }

    // MARK: Transaction flow

    /// executes payment transaction flow
    /// - Parameter jwt: jwt token (provide if you want to update the token - you use defer init)
    /// - Parameter typeDescriptions: request types (AUTH, THREEDQUERY...)
    /// - Parameter card: bank card object (if there is a nil, the assumption is that a transaction with a parent transaction reference is made)
    /// - Parameter transactionSuccessClosure: Closure triggered after a successful payment transaction
    /// - Parameter transactionErrorClosure: Closure triggered after a failed transaction, when a error was returned at some stage
    /// - Parameter cardinalAuthenticationErrorClosure: Closure triggered after a failed transaction, when a cardinal authentication error was returned
    /// - Parameter validationErrorClosure: Closure triggered after a failed transaction, when a validation error was returned
    public func performTransaction(jwt: String? = nil, typeDescriptions: [TypeDescription], card: Card?, transactionSuccessClosure: ((JWTResponseObject, STCardReference?) -> Void)?, transactionErrorClosure: ((JWTResponseObject?, String) -> Void)?, cardinalAuthenticationErrorClosure: (() -> Void)?, validationErrorClosure: ((ResponseErrorDetail) -> Void)?) {
        if let jwt = jwt {
            self.jwt = jwt
        }

        self.typeDescriptions = typeDescriptions

        self.card = card

        self.transactionSuccessClosure = transactionSuccessClosure
        self.transactionErrorClosure = transactionErrorClosure
        self.cardinalAuthenticationErrorClosure = cardinalAuthenticationErrorClosure
        self.validationErrorClosure = validationErrorClosure

        if !self.isDeferInit {
            guard self.isJsInitCompleted else {
                self.shouldStartTransactionAfterJsInit = true
                return
            }

            let (responseObject, jsInitError) = self.jsInitError
            guard let jsInitErrorTemp = jsInitError else {
                self.makePaymentOrThreeDQueryRequest()
                return
            }

            self.transactionErrorClosure?(responseObject, jsInitErrorTemp)
        } else {
            self.makeJSInitRequest(completion: { [weak self] _ in
                guard let self = self else { return }
                self.makePaymentOrThreeDQueryRequest()
            }, failure: { [weak self] responseObject, errorMessage in
                guard let self = self else { return }
                self.transactionErrorClosure?(responseObject, errorMessage)
            })
        }
    }

    // objc workaround
    /// executes payment transaction flow
    /// - Parameter jwt: jwt token (provide if you want to update the token - you use defer init)
    /// - Parameter typeDescriptions: request types (AUTH, THREEDQUERY...)
    /// - Parameter card: bank card object (if there is a nil, the assumption is that a transaction with a parent transaction reference is made)
    /// - Parameter transactionSuccessClosure: Closure triggered after a successful payment transaction
    /// - Parameter transactionErrorClosure: Closure triggered after a failed transaction, when a error was returned at some stage
    /// - Parameter cardinalAuthenticationErrorClosure: Closure triggered after a failed transaction, when a cardinal authentication error was returned
    /// - Parameter validationErrorClosure: Closure triggered after a failed transaction, when a validation error was returned
    @objc public func performTransaction(jwt: String? = nil, typeDescriptions: [Int], card: Card?, transactionSuccessClosure: ((JWTResponseObject, STCardReference?) -> Void)?, transactionErrorClosure: ((JWTResponseObject?, String) -> Void)?, cardinalAuthenticationErrorClosure: (() -> Void)?, validationErrorClosure: ((ResponseErrorDetail) -> Void)?) {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        let typeDescriptionsSwift = objcTypes.map { TypeDescription(rawValue: $0.value)! }

        // swiftlint:disable line_length
        self.performTransaction(jwt: jwt, typeDescriptions: typeDescriptionsSwift, card: card, transactionSuccessClosure: transactionSuccessClosure, transactionErrorClosure: transactionErrorClosure, cardinalAuthenticationErrorClosure: cardinalAuthenticationErrorClosure, validationErrorClosure: validationErrorClosure)
        // swiftlint:enable line_length
    }

    // MARK: 3DSecure flow

    /// Checking if it is possible to perform a 3dsecure check (Cardinal Authentication)
    /// - Parameter responseObject: response object from threedquery request
    private func handleThreeDSecureFlow(responseObject: JWTResponseObject) {
        // bypass 3dsecure
        guard let cardEnrolled = responseObject.cardEnrolled, responseObject.acsUrl != nil, cardEnrolled == "Y" else {
            let tempTypeDescription = self.typeDescriptions.filter { $0 != .threeDQuery }
            // swiftlint:disable line_length
            let request = RequestObject(typeDescriptions: tempTypeDescription, requestId: self.requestId, cardNumber: self.card?.cardNumber.rawValue, securityCode: self.card?.securityCode?.rawValue, expiryDate: self.card?.expiryDate.rawValue, cacheToken: self.jsInitCacheToken)
            // swiftlint:enable line_length

            self.makePaymentRequest(request: request, success: { [weak self] responseObject in
                guard let self = self else { return }
                self.transactionSuccessClosure?(responseObject, responseObject.cardReference)
            }, transactionError: { [weak self] responseObject, error in
                guard let self = self else { return }
                self.transactionErrorClosure?(responseObject, error)
            }, validationError: { [weak self] errorCode in
                guard let self = self else { return }
                self.validationErrorClosure?(errorCode)
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
        var cardinalAuthenticationError: Bool = false

        dispatchQueue.async {
            dispatchGroup.enter()
            self.threeDSecureManager.continueSession(with: transactionId, payload: transactionPayload, sessionAuthenticationValidateJWT: { jwt in
                jwtForValidation = jwt
                dispatchSemaphore.signal()
                dispatchGroup.leave()
            }, sessionAuthenticationFailure: {
                cardinalAuthenticationError = true
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
            }, transactionError: { responseObject, error in
                jwtResponseObject = responseObject
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
                if cardinalAuthenticationError {
                    self.cardinalAuthenticationErrorClosure?()
                    return
                }

                if let error = transactionError {
                    self.transactionErrorClosure?(jwtResponseObject, error)
                    return
                }

                if let errorCode = validationError {
                    self.validationErrorClosure?(errorCode)
                    return
                }

                self.transactionSuccessClosure?(jwtResponseObject!, jwtResponseObject!.cardReference)
            }
        }
    }

    // MARK: Validation

    public func handleCardinalWarnings(cardinalWarningsCompletion: ((String, [CardinalInitWarnings]) -> Void)?) {
        let warnings = self.threeDSecureManager.warnings
        guard !warnings.isEmpty else { return }
        let warningsErrorMessage = warnings.map { $0.localizedDescription }.joined(separator: ", ")
        cardinalWarningsCompletion?(warningsErrorMessage, warnings)
    }
}
