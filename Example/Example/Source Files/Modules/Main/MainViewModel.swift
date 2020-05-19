//
//  MainViewModel.swift
//  Example
//

import Foundation
import SwiftJWT

final class MainViewModel {

    /// - SeeAlso: AppFoundation.apiManager
    let apiManager: APIManager

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiManager: API manager
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func makeAuthCall() {

        let claim = STClaims(iss: "jwt-pgsmobilesdk",
        iat: Date(timeIntervalSinceNow: 60),
        payload: Payload(accounttypedescription: "ECOM",
                         sitereference: "test_pgsmobilesdk79458",
                         currencyiso3a: "GBP",
                         baseamount: 1050,
                         pan: "4111111111111111",
                         expirydate: "12/2022",
                         securitycode: "123"))


        
    }

    private func checkAPIManager() {
        // swiftlint:disable line_length
        let generatedJWT = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJqd3QtcGdzbW9iaWxlc2RrIiwiaWF0IjoxNTg5NTI0Nzc2Ljk5MDA0NTEsInBheWxvYWQiOnsiZXhwaXJ5ZGF0ZSI6IjEyXC8yMDIyIiwiYmFzZWFtb3VudCI6MTA1MCwicGFuIjoiNDExMTExMTExMTExMTExMSIsInNlY3VyaXR5Y29kZSI6IjEyMyIsImFjY291bnR0eXBlZGVzY3JpcHRpb24iOiJFQ09NIiwic2l0ZXJlZmVyZW5jZSI6InRlc3RfcGdzbW9iaWxlc2RrNzk0NTgiLCJjdXJyZW5jeWlzbzNhIjoiR0JQIn19.DvrtwnTw7FcIxNN8-BkrKyib0DquFQNKVrKL_kj6nXA"
        // swiftlint:enable line_length
        let authRequest = RequestObject(typeDescriptions: [.auth])
        apiManager.checkJWTDecoding()
        //appFoundation.apiManager.makeGeneralRequest(jwt: generatedJWT, requests: [authRequest])
    }

    let test = ObjectiveCTest()
    private func checkAPIManagerFromObjc() {
        test.someTestMethod()
    }
}
