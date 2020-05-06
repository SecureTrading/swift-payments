//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by TIWASZEK on 06/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import XCTest
import SecureTradingUI
import SecureTradingCore
@testable import SecureTradingApp

class ExampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // Test Core framework availability
        let apiClient = DefaultAPIClient()
        // Test UI framework availability
        let cardVC = CardViewController(view: CardView(), viewModel: CardViewModel())
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
