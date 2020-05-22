//
//  TestCardType.swift
//  SecureTradingCardTests
//
//  Created by MCHRZASTEK on 22/05/2020.
//

import XCTest
@testable import SecureTradingCard

class TestCardType: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func test_isVisa() {
        let visaCards = KnownCards.visaCards
        
        for card in visaCards {
            XCTAssertEqual(CardType.visa, CardValidator.cardType(for: card))
        }
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
