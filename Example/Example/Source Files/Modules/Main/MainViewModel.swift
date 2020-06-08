//
//  MainViewModel.swift
//  Example
//

import Foundation
import SwiftJWT

final class MainViewModel {
    // MARK: Properties

    /// - SeeAlso: AppFoundation.apiManager
    private let apiManager: APIManager

    /// Keys for certain scheme
    private let keys = ApplicationKeys(keys: ExampleKeys())

    var showAuthSuccess: ((ResponseSettleStatus) -> Void)?
    var showAuthError: ((String) -> Void)?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiManager: API manager
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    // MARK: Functions

    func getJwtTokenWithoutCardData() -> String? {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1050,
                                              pan: nil,
                                              expirydate: nil,
                                              securitycode: nil))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return nil }
        return jwt
    }

    func makeAuthCall() {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1100,
                                              pan: "4111111111111111",
                                              expirydate: "12/2022",
                                              securitycode: "123"))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }

        let authRequest = RequestObject(typeDescriptions: [.auth])

        apiManager.makeGeneralRequest(jwt: jwt, request: authRequest, success: { [weak self] responseObject, _ in
            guard let self = self else { return }
            switch responseObject.responseErrorCode {
            case .successful:
                self.showAuthSuccess?(responseObject.responseSettleStatus)
            default:
                // transaction error
                self.showAuthError?(responseObject.errorMessage)
            }
        }, failure: { [weak self] error in
            guard let self = self else { return }
            switch error {
            case .responseValidationError(let responseError):
                switch responseError {
                case .invalidField(let errorCode):
                    var message = "Invalid field: "
                    switch errorCode {
                    case .invalidPAN: message += "PAN"
                    case .invalidSecurityCode: message += "Security code"
                    case .invalidJWT: message += "JWT"
                    case .invalidExpiryDate: message += "Expiry date"
                    case .invalidTermURL: message += "Terms URL"
                    case .none: message += ""
                    }
                    // Update UI
                    self.showAuthError?(message)
                default:
                    self.showAuthError?(error.humanReadableDescription)
                }
            default:
                self.showAuthError?(error.humanReadableDescription)
            }
        })
    }
}
