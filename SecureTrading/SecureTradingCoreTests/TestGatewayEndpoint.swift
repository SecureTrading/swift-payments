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
        let jwt = invalidJWTEmpty
        let expectedError = APIClientError.jwtDecodingInvalidPartCount
        XCTAssertThrowsError(try DecodedJWT(jwt: jwt)) { (error) in
            let receivedError = (error as? APIClientError)?.humanReadableDescription
            XCTAssertEqual(expectedError.humanReadableDescription, receivedError)
        }
    }
    func test_throwsForTooManyJWTComponent() {
        let jwt = invalidJWTEmpty
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
private var invalidJWTEmpty: String {
    return ""
}

private var invalidJWTTooManyComponents: String {
    return "aa.bb.cc.dd"
}

// Helper methods

private func data(for json: Any) -> Data {
    return try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions(rawValue: 0))
}

private func base64urlEncodedString(data: Data) -> String {
    let result = data.base64EncodedString()
    return result.replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
}

//private var validJWT: String {
//    return  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1OTA1ODIxNDIsInBheWxvYWQiOnsicmVxdWVzdHJlZmVyZW5jZSI6Ilc1Ny1hdWJrM2RyMyIsInZlcnNpb24iOiIxLjAwIiwiand0IjoiZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnBjM01pT2lKcWQzUXRjR2R6Ylc5aWFXeGxjMlJySWl3aWFXRjBJam94TlRrd05UZ3lNVFF5TENKd1lYbHNiMkZrSWpwN0ltTjFjbkpsYm1ONWFYTnZNMkVpT2lKSFFsQWlMQ0ppWVhObFlXMXZkVzUwSWpveE1EVXdMQ0p6YVhSbGNtVm1aWEpsYm1ObElqb2lkR1Z6ZEY5d1ozTnRiMkpwYkdWelpHczNPVFExT0NJc0ltVjRjR2x5ZVdSaGRHVWlPaUl4TWk4eU1ESXlJaXdpY0dGeVpXNTBkSEpoYm5OaFkzUnBiMjV5WldabGNtVnVZMlVpT2lJMU55MDVMVEU0TURnM0lpd2ljMlZqZFhKcGRIbGpiMlJsSWpvaU1USXpJaXdpWVdOamIzVnVkSFI1Y0dWa1pYTmpjbWx3ZEdsdmJpSTZJa1ZEVDAwaUxDSndZVzRpT2lJME1URXhNVEV4TVRFeE1URXhNVEV4SW4xOS5LRVFhc1Q0UmN2LXBfYlFkQTZPdURuS2E0V3l2Y3F2TTQzQXE2T1QwSTBFIiwicmVzcG9uc2UiOlt7InRyYW5zYWN0aW9uc3RhcnRlZHRpbWVzdGFtcCI6IjIwMjAtMDUtMjcgMTI6MjI6MjIiLCJsaXZlc3RhdHVzIjoiMCIsImlzc3VlciI6IlNlY3VyZVRyYWRpbmcgVGVzdCBJc3N1ZXIxIiwic3BsaXRmaW5hbG51bWJlciI6IjEiLCJkY2NlbmFibGVkIjoiMCIsInNldHRsZWR1ZWRhdGUiOiIyMDIwLTA1LTI3IiwiZXJyb3Jjb2RlIjoiMCIsInRpZCI6IjI3ODgyNzg4IiwibWVyY2hhbnRudW1iZXIiOiIwMDAwMDAwMCIsInNlY3VyaXR5cmVzcG9uc2Vwb3N0Y29kZSI6IjAiLCJ0cmFuc2FjdGlvbnJlZmVyZW5jZSI6IjU3LTktMTgwODciLCJtZXJjaGFudG5hbWUiOiJwZ3MgbW9iaWxlIHNkayIsInBheW1lbnR0eXBlZGVzY3JpcHRpb24iOiJWSVNBIiwiYmFzZWFtb3VudCI6IjEwNTAiLCJhY2NvdW50dHlwZWRlc2NyaXB0aW9uIjoiRUNPTSIsImFjcXVpcmVycmVzcG9uc2Vjb2RlIjoiMDAiLCJyZXF1ZXN0dHlwZWRlc2NyaXB0aW9uIjoiQVVUSCIsInNlY3VyaXR5cmVzcG9uc2VzZWN1cml0eWNvZGUiOiIyIiwiY3VycmVuY3lpc28zYSI6IkdCUCIsImF1dGhjb2RlIjoiVEVTVDk1IiwiZXJyb3JtZXNzYWdlIjoiT2siLCJpc3N1ZXJjb3VudHJ5aXNvMmEiOiJVUyIsIm1lcmNoYW50Y291bnRyeWlzbzJhIjoiR0IiLCJtYXNrZWRwYW4iOiI0MTExMTEjIyMjIyMxMTExIiwic2VjdXJpdHlyZXNwb25zZWFkZHJlc3MiOiIwIiwib3BlcmF0b3JuYW1lIjoiand0LXBnc21vYmlsZXNkayIsInNldHRsZXN0YXR1cyI6IjAifV0sInNlY3JhbmQiOiJFOG5aNTN0cklpRERjZmwifSwiYXVkIjoiand0LXBnc21vYmlsZXNkayJ9.njV_OISIDtVCvCsoewUvV2sou2dDLS8kvgL8P-L0r7E"
//}
