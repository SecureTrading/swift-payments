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

    func makeAuthCall() {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 60),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1050,
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
        }) { [weak self] _ in
            guard let self = self else { return }
            // general connection error
            self.showAuthError?("general connection or decoding error")
        }
    }

    private func checkAPIManager() {
        // swiftlint:disable line_length
        let generatedJWT = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJqd3QtcGdzbW9iaWxlc2RrIiwiaWF0IjoxNTg5NTI0Nzc2Ljk5MDA0NTEsInBheWxvYWQiOnsiZXhwaXJ5ZGF0ZSI6IjEyXC8yMDIyIiwiYmFzZWFtb3VudCI6MTA1MCwicGFuIjoiNDExMTExMTExMTExMTExMSIsInNlY3VyaXR5Y29kZSI6IjEyMyIsImFjY291bnR0eXBlZGVzY3JpcHRpb24iOiJFQ09NIiwic2l0ZXJlZmVyZW5jZSI6InRlc3RfcGdzbW9iaWxlc2RrNzk0NTgiLCJjdXJyZW5jeWlzbzNhIjoiR0JQIn19.DvrtwnTw7FcIxNN8-BkrKyib0DquFQNKVrKL_kj6nXA"
        // swiftlint:enable line_length
        let authRequest = RequestObject(typeDescriptions: [.auth])
        // appFoundation.apiManager.makeGeneralRequest(jwt: generatedJWT, requests: [authRequest])
        apiManager.checkJWTDecoding()
    }

    let test = ObjectiveCTest()
    func checkAPIManagerFromObjc() {
        test.someTestMethod()
    }
}
