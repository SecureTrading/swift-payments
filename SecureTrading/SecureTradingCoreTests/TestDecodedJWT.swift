//
//  TestDecodedJWT.swift
//  SecureTradingCoreTests
//

import XCTest
@testable import SecureTradingCore

class TestDecodedJWT: XCTestCase {
    
    // MARK: Test Decoded JWT
    func test_throwsForEmptyJWT() {
        let jwt = ""
        let expectedError = APIClientError.jwtDecodingInvalidPartCount
        XCTAssertThrowsError(try DecodedJWT(jwt: jwt)) { (error) in
            let receivedError = (error as? APIClientError)?.humanReadableDescription
            XCTAssertEqual(expectedError.humanReadableDescription, receivedError)
        }
    }
    func test_throwsForTooManyJWTComponent() {
        let jwt = "aa.bb.cc.dd"
        let expectedError = APIClientError.jwtDecodingInvalidPartCount
        XCTAssertThrowsError(try DecodedJWT(jwt: jwt)) { (error) in
            let receivedError = (error as? APIClientError)?.humanReadableDescription
            XCTAssertEqual(expectedError.humanReadableDescription, receivedError)
        }
    }
    func test_throwsForInvalidResponseBody() {
        let jwt = [headerJSON.data.base64URLEncoded,
                   headerJSON.data.base64URLEncoded,
                   signature
            ].joined(separator: ".")
        XCTAssertThrowsError(try DecodedJWT(jwt: jwt))
    }
    func test_DoesntThrowForValidResponseBody() {
        XCTAssertNoThrow(try DecodedJWT(jwt: getJWT()))
    }
    func test_responseHasAudience() {
        XCTAssertNotNil(try DecodedJWT(jwt: getJWT()).audience)
    }
    func test_responseHasIssuedAt() {
        XCTAssertNotNil(try DecodedJWT(jwt: getJWT()).issuedAt)
    }
    func test_responseHasTransactionReference() throws {
        let responses = try DecodedJWT(jwt: getJWT()).jwtBodyResponse.responses
        for response in responses {
            XCTAssertNotNil(response.transactionReference)
        }
    }
    func test_responseHasErrorCodeZeroForSuccess() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["errorcode": "0"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.successful)
        }
    }
    func test_responseHasErrorCode70_000DeclinedByBank() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["errorcode": "70000"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.declinedByIssuingBank)
        }
    }
    func test_responseHasErrorCode60_022Unauthorized() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["errorcode": "60022"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.transactionNotAuhorised)
        }
    }
    func test_responseHasErrorCode30000FieldError() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["errorcode": "30000"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.fieldError)
        }
    }
    func test_responseHasErrorCode60034ManualInvestigationError() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["errorcode": "60034"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.manualInvestigationRequired)
        }
    }
    func test_responseHasErrorCodeMinus2Unknown() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["errorcode": "-2"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.unknown)
        }
    }
    func test_responseHasErrorCodeMissingUnknown() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["errorcode": ""])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.unknown)
        }
    }
    func test_responseHasSettleCode0AutoPending() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["settlestatus": "0"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.pendingAutomaticSettlement)
        }
    }
    func test_responseHasSettleCode1ManualPending() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["settlestatus": "1"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.pendingManualSettlement)
        }
    }
    func test_responseHasSettleCode2Suspended() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["settlestatus": "2"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.paymentAuthorisedButSuspended)
        }
    }
    func test_responseHasSettleCode3Cancelled() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["settlestatus": "3"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.paymentCancelled)
        }
    }
    func test_responseHasSettleCode10InPogress() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["settlestatus": "10"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.settlementInProgress)
        }
    }
    func test_responseHasSettleCode100InstantSettlement() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["settlestatus": "100"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.instantSettlement)
        }
    }
    func test_responseHasSettleCodeMinus1ErrorUnhandled() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["settlestatus": "-1"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.error)
        }
    }
    func test_responseHasSettleCodeMinus1Empty() throws {
        let body = modify(newBodyFields: [:], newResponseFields: ["settlestatus": ""])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.error)
        }
    }
    func test_bodyHasIssuer() throws {
        let expected = "Secure Trading"
        let body = modify(newBodyFields: ["iss": expected], newResponseFields: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.issuer, expected)
    }
    func test_bodyHasSubject() throws {
        let expected = "Secure Trading"
        let body = modify(newBodyFields: ["sub": expected], newResponseFields: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.subject, expected)
    }
    func test_bodyHasIdentifier() throws {
        let expected = "Secure Trading"
        let body = modify(newBodyFields: ["jti": expected], newResponseFields: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.identifier, expected)
    }
    func test_bodyHasNotBeforeDate() throws {
        let expected = Date().addingTimeInterval(1).timeIntervalSince1970
        let body = modify(newBodyFields: ["nbf": expected], newResponseFields: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.notBefore, Date(timeIntervalSince1970: expected))
    }
    func test_bodyHasExpirationDate() throws {
        let expected = Date().addingTimeInterval(1).timeIntervalSince1970
        let body = modify(newBodyFields: ["exp": expected], newResponseFields: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.expiresAt, Date(timeIntervalSince1970: expected))
    }
    func test_bodyExpirationDateValidForEmpty() throws {
        let body = modify(newBodyFields: [:], newResponseFields: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertFalse(decodedJWT.expired)
    }
    func test_bodyExpirationDateInPastIsExpired() throws {
        let expected = Date().addingTimeInterval(-1).timeIntervalSince1970
        let body = modify(newBodyFields: ["exp": expected], newResponseFields: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertTrue(decodedJWT.expired)
    }
    func test_claimCanReadInt() throws {
        let expected = 10
        let body = modify(newBodyFields: ["int": (expected)], newResponseFields: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.claim(name: "int").integer, expected)
    }
    func test_claimCanReadIntFromString() throws {
        let expected = 10
        let body = modify(newBodyFields: ["int": "\(expected)"], newResponseFields: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.claim(name: "int").integer, expected)
    }
}

// MARK: Helper methods
func getJWT(withBody body: [String: Any]? = nil) -> String {
    if let body = body {
        return [
            headerJSON.data.base64URLEncoded,
            body.data.base64URLEncoded,
            signature
            ].joined(separator: ".")
    } else {
        return [
            headerJSON.data.base64URLEncoded,
            modify(newBodyFields: [:], newResponseFields: [:]).data.base64URLEncoded,
            signature
            ].joined(separator: ".")
    }
}

func modify(newBodyFields: [String: Any], newResponseFields: [String: Any]) -> [String: Any] {
    var response = baseResponseJSON
    for field in newResponseFields {
        response[field.key] = field.value
    }
    var baseResponse = baseResponseBodyJSON
    for field in newBodyFields {
        baseResponse[field.key] = field.value
    }
    baseResponse["payload"] = ["response": [response]]
    return baseResponse
}

private var headerJSON: [String: String] {
    return [
        "alg": "HS256",
        "typ": "JWT"
    ]
}
private var baseResponseBodyJSON: [String: Any] {
    return [
        "aud": "jwt-pgsmobilesdk",
        "iat": 1590582142,
        "payload":
            [
                "response": [baseResponseJSON]
        ]
    ]
}
private var baseResponseJSON: [String: Any] {
    return [
        "transactionstartedtimestamp": "2020-05-27 12:22:22",
        "livestatus": "0",
        "issuer": "SecureTrading Test Issuer1",
        "splitfinalnumber": "1",
        "dccenabled": "0",
        "settleduedate": "2020-05-27",
        "errorcode": "0",
        "tid": "27882788",
        "merchantnumber": "00000000",
        "securityresponsepostcode": "0",
        "transactionreference": "57-9-18087",
        "merchantname": "pgs mobile sdk",
        "paymenttypedescription": "VISA",
        "baseamount": "1050",
        "accounttypedescription": "ECOM",
        "acquirerresponsecode": "00",
        "requesttypedescription": "AUTH",
        "securityresponsesecuritycode": "2",
        "currencyiso3a": "GBP",
        "authcode": "TEST95",
        "errormessage": "Ok",
        "issuercountryiso2a": "US",
        "merchantcountryiso2a": "GB",
        "maskedpan": "411111######1111",
        "securityresponseaddress": "0",
        "operatorname": "jwt-pgsmobilesdk",
        "settlestatus": "0"
    ]
}
private var signature: String {
    return "signature"
}
private extension Dictionary where Key == String, Value: Any {
    var data: Data {
        // swiftlint:disable force_try
        return try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
}
private extension Data {
    var base64URLEncoded: String {
        let result = self.base64EncodedString()
        return result.replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
