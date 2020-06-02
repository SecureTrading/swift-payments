//
//  TestRequestObject.swift
//  SecureTradingCoreTests
//

import XCTest
@testable import SecureTradingCore

class TestRequestObject: XCTestCase {
    func test_HasAllSetTypesAsTypeDescription() {
        let typeDescriptions: [TypeDescription] = [.auth, .threeDQuery]
        let request = RequestObject(typeDescriptions: typeDescriptions)
        XCTAssertEqual(typeDescriptions.count, request.typeDescriptions.count)
    }
    func test_HasAllSetTypesAsInt() {
        let typeDescriptions: [Int] = [0, 1]
        let request = RequestObject(typeDescriptions: typeDescriptions)
        XCTAssertEqual(typeDescriptions.count, request.typeDescriptions.count)
    }
    func test_doesntCrashOnInvalidIDs() {
        let typeDescriptions: [Int] = [100, 200]
        let request = RequestObject(typeDescriptions: typeDescriptions)
        XCTAssertEqual(0, request.typeDescriptions.count)
    }
}
