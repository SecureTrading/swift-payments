//
//  TestGatewayEndpoint.swift
//  SecureTradingCoreTests
//

import XCTest
@testable import SecureTradingCore

class TestGatewayEndpoint: XCTestCase {
    
    func test_gatewayEndpointForEU() {
        let expected = "webservices.securetrading.net"
        let sut = GatewayType.eu.host
        XCTAssertEqual(expected, sut)
    }
    func test_gatewayEndpointForUS() {
        let expected = "webservices.securetrading.us"
        let sut = GatewayType.us.host
        XCTAssertEqual(expected, sut)
    }
    
    // MARK: - Test Decoded JWT
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
        let jwt = jwtInvalidResponseBody
        XCTAssertThrowsError(try DecodedJWT(jwt: jwt))
    }
    func test_DoesntThrowForValidResponseBody() {
        let jwt = jwtValidResponseBody
        XCTAssertNoThrow(try DecodedJWT(jwt: jwt))
    }
    func test_responseHasAudience() {
        let jwt = jwtValidResponseBody
        XCTAssertNotNil(try DecodedJWT(jwt: jwt).audience)
    }
    func test_responseHasIssuedAt() {
        let jwt = jwtValidResponseBody
        XCTAssertNotNil(try DecodedJWT(jwt: jwt).issuedAt)
    }
    func test_responseHasTransactionReference() throws {
        let jwt = jwtValidResponseBody
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertNotNil(response.transactionReference)
        }
    }
    func test_responseHasErrorCodeZeroForSuccess() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["errorcode": "0"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.successful)
        }
    }
    func test_responseHasErrorCode70_000DeclinedByBank() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["errorcode": "70000"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.declinedByIssuingBank)
        }
    }
    func test_responseHasErrorCode60_022Unauthorized() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["errorcode": "60022"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.transactionNotAuhorised)
        }
    }
    func test_responseHasErrorCode3000FieldError() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["errorcode": "3000"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.fieldError)
        }
    }
    func test_responseHasErrorCode60034ManualInvestigationError() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["errorcode": "60034"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.manualInvestigationRequired)
        }
    }
    func test_responseHasErrorCodeMinus2Unknown() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["errorcode": "-2"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.unknown)
        }
    }
    func test_responseHasErrorCodeMissingUnknown() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["errorcode": ""])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseErrorCode, ResponseErrorCode.unknown)
        }
    }
    func test_responseHasSettleCode0AutoPending() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["settlestatus": "0"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.pendingAutomaticSettlement)
        }
    }
    func test_responseHasSettleCode1ManualPending() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["settlestatus": "1"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.pendingManualSettlement)
        }
    }
    func test_responseHasSettleCode2Suspended() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["settlestatus": "2"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.paymentAuthorisedButSuspended)
        }
    }
    func test_responseHasSettleCode3Cancelled() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["settlestatus": "3"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.paymentCancelled)
        }
    }
    func test_responseHasSettleCode10InPogress() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["settlestatus": "10"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.settlementInProgress)
        }
    }
    func test_responseHasSettleCode100InstantSettlement() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["settlestatus": "100"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.instantSettlement)
        }
    }
    func test_responseHasSettleCodeMinus1ErrorUnhandled() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["settlestatus": "-1"])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.error)
        }
    }
    func test_responseHasSettleCodeMinus1Empty() throws {
        let body = modifyResponseBody(fieldsToUpdate: ["settlestatus": ""])
        let jwt = getJWT(withBody: body)
        let responses = try DecodedJWT(jwt: jwt).jwtBodyResponse.responses
        for response in responses {
            XCTAssertEqual(response.responseSettleStatus, ResponseSettleStatus.error)
        }
    }
    func test_bodyHasIssuer() throws {
        let expected = "Secure Trading"
        let body = modifyBody(fieldsToUpdate: ["iss": expected])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.issuer, expected)
    }
    func test_bodyHasSubject() throws {
        let expected = "Secure Trading"
        let body = modifyBody(fieldsToUpdate: ["sub": expected])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.subject, expected)
    }
    func test_bodyHasIdentifier() throws {
        let expected = "Secure Trading"
        let body = modifyBody(fieldsToUpdate: ["jti": expected])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.identifier, expected)
    }
    func test_bodyHasNotBeforeDate() throws {
        let expected = Date().addingTimeInterval(1).timeIntervalSince1970
        let body = modifyBody(fieldsToUpdate: ["nbf": expected])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.notBefore, Date(timeIntervalSince1970: expected))
    }
    func test_bodyHasExpirationDate() throws {
        let expected = Date().addingTimeInterval(1).timeIntervalSince1970
        let body = modifyBody(fieldsToUpdate: ["exp": expected])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.expiresAt, Date(timeIntervalSince1970: expected))
    }
    func test_bodyExpirationDateValidForEmpty() throws {
        let body = modifyBody(fieldsToUpdate: [:])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertFalse(decodedJWT.expired)
    }
    func test_bodyExpirationDateInPastIsExpired() throws {
        let expected = Date().addingTimeInterval(-1).timeIntervalSince1970
        let body = modifyBody(fieldsToUpdate: ["exp": expected])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertTrue(decodedJWT.expired)
    }
    func test_claimCanReadInt() throws {
        let expected = 10
        let body = modifyBody(fieldsToUpdate: ["int": expected])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.claim(name: "int").integer, expected)
    }
    func test_claimCanReadIntFromString() throws {
        let expected = 10
        let body = modifyBody(fieldsToUpdate: ["int": "\(expected)"])
        let jwt = getJWT(withBody: body)
        let decodedJWT = try DecodedJWT(jwt: jwt)
        XCTAssertEqual(decodedJWT.claim(name: "int").integer, expected)
    }
   
    
}

private var jwtInvalidResponseBody: String {
    return [
        base64urlEncodedString(data: data(for: validHeaderJSON)),
        base64urlEncodedString(data: data(for: validHeaderJSON)),
        base64urlEncodedString(data: data(for: validHeaderJSON))
        ].joined(separator: ".")
}
private var jwtValidResponseBody: String {
    return [
        base64urlEncodedString(data: data(for: validHeaderJSON)),
        base64urlEncodedString(data: data(for: validResponseBodyJSON)),
        base64urlEncodedString(data: data(for: validHeaderJSON))
        ].joined(separator: ".")
}

// Helper methods
func getJWT(withBody body: [String: Any]) -> String {
    return [
        base64urlEncodedString(data: data(for: validHeaderJSON)),
        base64urlEncodedString(data: data(for: body)),
        base64urlEncodedString(data: data(for: validHeaderJSON))
        ].joined(separator: ".")
}
private var validHeaderJSON: [String: String] {
    return [
        "alg": "HS256",
        "typ": "JWT"
    ]
}
func modifyResponseBody(fieldsToUpdate: [String: Any]) -> [String: Any] {
    var response = responseJSON
    for field in fieldsToUpdate {
        response[field.key] = field.value
    }
    return validResponseBodyJSON(withResponse: response)
}
func modifyBody(fieldsToUpdate: [String: Any]) -> [String: Any] {
    var body = validResponseBodyJSON(withResponse: responseJSON)
    for field in fieldsToUpdate {
        body[field.key] = field.value
    }
    return body
}
var responseJSON: [String: Any] {
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
func validResponseBodyJSON(withResponse response: [String: Any]) -> [String: Any] {
    return [
        "aud": "jwt-pgsmobilesdk",
        "iat": 1590582142,
        "payload":
            [
                "response": [
                    response
                ]
        ]
    ]
}
private var validResponseBodyJSON: [String: Any] {
    [
        "aud": "jwt-pgsmobilesdk",
        "iat": 1590582142,
        "payload":
            [
                "response": [
                    responseJSON
                ]
        ]
    ]
}

//{
//  "iat": 1590582142,
//  "payload": {
//    "requestreference": "W57-aubk3dr3",
//    "version": "1.00",
//    "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJqd3QtcGdzbW9iaWxlc2RrIiwiaWF0IjoxNTkwNTgyMTQyLCJwYXlsb2FkIjp7ImN1cnJlbmN5aXNvM2EiOiJHQlAiLCJiYXNlYW1vdW50IjoxMDUwLCJzaXRlcmVmZXJlbmNlIjoidGVzdF9wZ3Ntb2JpbGVzZGs3OTQ1OCIsImV4cGlyeWRhdGUiOiIxMi8yMDIyIiwicGFyZW50dHJhbnNhY3Rpb25yZWZlcmVuY2UiOiI1Ny05LTE4MDg3Iiwic2VjdXJpdHljb2RlIjoiMTIzIiwiYWNjb3VudHR5cGVkZXNjcmlwdGlvbiI6IkVDT00iLCJwYW4iOiI0MTExMTExMTExMTExMTExIn19.KEQasT4Rcv-p_bQdA6OuDnKa4WyvcqvM43Aq6OT0I0E",
//    "response": [
//      {
//        "transactionstartedtimestamp": "2020-05-27 12:22:22",
//        "livestatus": "0",
//        "issuer": "SecureTrading Test Issuer1",
//        "splitfinalnumber": "1",
//        "dccenabled": "0",
//        "settleduedate": "2020-05-27",
//        "errorcode": "0",
//        "tid": "27882788",
//        "merchantnumber": "00000000",
//        "securityresponsepostcode": "0",
//        "transactionreference": "57-9-18087",
//        "merchantname": "pgs mobile sdk",
//        "paymenttypedescription": "VISA",
//        "baseamount": "1050",
//        "accounttypedescription": "ECOM",
//        "acquirerresponsecode": "00",
//        "requesttypedescription": "AUTH",
//        "securityresponsesecuritycode": "2",
//        "currencyiso3a": "GBP",
//        "authcode": "TEST95",
//        "errormessage": "Ok",
//        "issuercountryiso2a": "US",
//        "merchantcountryiso2a": "GB",
//        "maskedpan": "411111######1111",
//        "securityresponseaddress": "0",
//        "operatorname": "jwt-pgsmobilesdk",
//        "settlestatus": "0"
//      }
//    ],
//    "secrand": "E8nZ53trIiDDcfl"
//  },
//  "aud": "jwt-pgsmobilesdk"
//}
private var signature: String {
    return "signature"
}

private func data(for json: Any) -> Data {
    return try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))
}

private func base64urlEncodedString(data: Data) -> String {
    let result = data.base64EncodedString()
    return result.replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
}





