//
//  TestGeneralResponse.swift
//  SecureTradingCoreTests
//

import XCTest
@testable import SecureTradingCore

class TestGeneralResponse: XCTestCase {
    func test_smth() throws {
        let jwtData = getJWT().data(using: .utf8)!
        //let response = try JSONDecoder().decode(GeneralResponse.self, from: jwtData)
       // print(response)
    }
}
