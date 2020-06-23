//
//  AddCardViewModel.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCard
import SecureTradingCore
#endif
import Foundation

final class AddCardViewModel {
    // MARK: Properties

    private let jwt: String

    /// - SeeAlso: SecureTradingCore.apiManager
    private let apiManager: APIManager

    private let typeDescriptions: [TypeDescription]

    private var card: Card?

    var showCardAddedSuccess: ((STCardReference?) -> Void)?
    var showAuthError: ((String) -> Void)?
    var showValidationError: ((ResponseErrorDetail) -> Void)?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiManager: API manager
    /// - Parameter jwt: jwt token
    /// - Parameter typeDescriptions: request types (AUTH, THREEDQUERY...)
    /// - Parameter gatewayType: gateway type (us or european)
    /// - Parameter username: merchant's username
    init(jwt: String, typeDescriptions: [TypeDescription], gatewayType: GatewayType, username: String) {
        self.jwt = jwt
        self.typeDescriptions = typeDescriptions
        self.apiManager = DefaultAPIManager(gatewayType: gatewayType, username: username)
    }

    // MARK: Functions

    /// makes payment transaction request
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

        self.apiManager.makeGeneralRequest(jwt: self.jwt, request: authRequest, success: { [weak self] responseObject, _, _ in
            guard let self = self else { return }
            switch responseObject.responseErrorCode {
            case .successful:
                self.showCardAddedSuccess?(responseObject.cardReference)
            default:
                self.showAuthError?(responseObject.errorMessage)
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
                    case .invalidParentTransactionReference, .invalidSiteReference:
                        self.showAuthError?(responseError.localizedDescription)
                    default: self.showAuthError?(error.humanReadableDescription)
                    }

                default:
                    self.showAuthError?(error.humanReadableDescription)
                }
            default:
                self.showAuthError?(error.humanReadableDescription)
            }
        })
    }

    /// Validates all input views in form
    /// - Parameter view: form view
    /// - Returns: result of validation
    @discardableResult
    func validateForm(view: AddCardView) -> Bool {
        let cardNumberValidationResult = view.cardNumberInput.validate(silent: false)
        let expiryDateValidationResult = view.expiryDateInput.validate(silent: false)
        let cvcValidationResult = view.cvcInput.validate(silent: false)
        return cardNumberValidationResult && expiryDateValidationResult && cvcValidationResult
    }
}
