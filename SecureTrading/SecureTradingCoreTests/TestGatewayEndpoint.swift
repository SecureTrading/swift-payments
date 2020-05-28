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

private var validHeaderJSON: [String: String] {
    return [
        "alg": "HS256",
        "typ": "JWT"
    ]
}
private var validResponseBodyJSON: [String: Any] {
    ["payload":
        [
            "response": [[
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
            ]]
        ]
    ]
}
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
