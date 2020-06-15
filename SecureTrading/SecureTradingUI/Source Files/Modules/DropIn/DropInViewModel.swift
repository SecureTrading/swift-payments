//
//  DropInViewModel.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCard
import SecureTradingCore
#endif
import Foundation

final class DropInViewModel {
    // MARK: Properties

    private let jwt: String

    /// - SeeAlso: SecureTradingCore.apiManager
    private let apiManager: APIManager

    private let typeDescriptions: [TypeDescription]

    private let isLiveStatus: Bool

    private let isDeferInit: Bool

    private var card: Card?

    var showTransactionSuccess: ((ResponseSettleStatus) -> Void)?
    var showTransactionError: ((String) -> Void)?
    var showValidationError: ((ResponseErrorDetail) -> Void)?

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
    }

    // MARK: Api requests

    /// executes payment transaction request
    /// - Parameters:
    ///   - cardNumber: The long number printed on the front of the customer’s card.
    ///   - securityCode: The three digit security code printed on the back of the card. (For AMEX cards, this is a 4 digit code found on the front of the card), This field is not strictly required.
    ///   - expiryDate: The expiry date printed on the card.
    func makeRequest(cardNumber: CardNumber, securityCode: CVC?, expiryDate: ExpiryDate) {
        self.card = Card(cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)
        let cardNumber = self.card?.cardNumber.rawValue
        let securityCode = self.card?.securityCode?.rawValue
        let expiryDate = self.card?.expiryDate.rawValue

        let authRequest = RequestObject(typeDescriptions: self.typeDescriptions, cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)

        self.apiManager.makeGeneralRequest(jwt: self.jwt, request: authRequest, success: { [weak self] responseObject, _ in
            guard let self = self else { return }
            switch responseObject.responseErrorCode {
            case .successful:
                self.showTransactionSuccess?(responseObject.responseSettleStatus)
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

    /// executes js init request - to get threeDInit (JWT token) to setup the Cardinal
    /// - Parameter completion: closure with following parameters: cache token and JWT token
    func makeJSInitRequest(completion: @escaping ((String, String) -> Void)) {

        let jsInitRequest = RequestObject(typeDescriptions: [.jsInit])

        self.apiManager.makeGeneralRequest(jwt: self.jwt, request: jsInitRequest, success: { [weak self] responseObject, _ in
            guard let self = self else { return }
            switch responseObject.responseErrorCode {
            case .successful:
                completion(responseObject.cacheToken!, responseObject.threeDInit!)
            default:
                self.showTransactionError?(responseObject.errorMessage)
            }
        }, failure: { [weak self] error in
            guard let self = self else { return }
            self.showTransactionError?(error.humanReadableDescription)
        })

    }

    // MARK: Transaction flow

    func performTransaction(cardNumber: CardNumber, securityCode: CVC?, expiryDate: ExpiryDate) {
        guard typeDescriptions.contains(.threeDQuery) else {
            makeRequest(cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)
            return
        }

        perform3DSecureFlow()
    }

    // MARK: 3DSecure flow

    func perform3DSecureFlow() {
        makeJSInitRequest { (cacheToken, threeDInit) in
            // todo
            print(cacheToken)
            print(threeDInit)
        }

    }

    // MARK: Validation

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
