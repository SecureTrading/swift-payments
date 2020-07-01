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
    func test_gatewayEndpointForEUBackup() {
        let expected = "webservices2.securetrading.net"
        let sut = GatewayType.euBackup.host
        XCTAssertEqual(expected, sut)
    }
    func test_gatewayEndpointForUS() {
        let expected = "webservices.securetrading.us"
        let sut = GatewayType.us.host
        XCTAssertEqual(expected, sut)
    }
}
