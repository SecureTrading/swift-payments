//
//  ExampleTests.swift
//  ExampleTests
//

@testable import SecureTradingApp
import SecureTradingCore
import SecureTradingUI
import XCTest

class ExampleTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // Test Core framework availability
        let apiClient = DefaultAPIClient()
        // Test UI framework availability
        let testMainVC = ViewControllerFactory.shared.testMainViewController {}
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
