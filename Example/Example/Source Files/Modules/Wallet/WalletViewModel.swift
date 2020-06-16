//
//  WalletViewModel.swift
//  Example
//

import Foundation

final class WalletViewModel {
    /// - SeeAlso: AppFoundation.apiManager
    private let apiManager: APIManager

    /// Keys for certain scheme
    private let keys = ApplicationKeys(keys: ExampleKeys())

    /// Stores temporary selected card reference
    private var selectedCard: STCardReference?

    /// Callbacks
    var showRequestSuccess: ((TypeDescription?) -> Void)?
    var showAuthError: ((String) -> Void)?

    /// Returns merchant user name without exposing Keys object
    var getUsername: String {
        return keys.merchantUsername
    }
    
    /// - Parameter apiManager: API manager
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    /// Called to store a reference for currently selected card on Wallet list
    /// - Parameter card: STCardReference object
    func cardSelected(_ card: STCardReference) {
        selectedCard = card
    }

    /// Performs an Auth request with selected card reference if selected card exists
    func performAuthRequest() {
        if let card = selectedCard {
            performAuthRequest(with: card)
        }
    }

    /// Return JWT containing all data needed for AUTH request except card information
    /// - Returns: JWT as String
    func getJwtTokenWithoutCardData() -> String? {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1050,
                                              pan: nil,
                                              expirydate: nil,
                                              securitycode: nil,
                                              parenttransactionreference: nil))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return nil }
        return jwt
    }

    /// Performs an Auth request with parent transaction reference, based on previously used card
    /// - Parameter card: STCardReference object
    private func performAuthRequest(with card: STCardReference) {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1100,
                                              pan: nil,
                                              expirydate: nil,
                                              securitycode: nil,
                                              parenttransactionreference: card.transactionReference)
        )

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }
        let authRequest = RequestObject(typeDescriptions: [.auth])
        makeRequest(with: jwt, request: authRequest)
    }

    private func makeRequest(with jwt: String, request: RequestObject) {
        apiManager.makeGeneralRequest(jwt: jwt, request: request, success: { [weak self] responseObject, _ in
            guard let self = self else { return }
            switch responseObject.responseErrorCode {
            case .successful:
                self.showRequestSuccess?(nil)
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
                        case .parentTransactionReference: message += "Parent transaction reference"
                        default: message += "Not applicable"
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
