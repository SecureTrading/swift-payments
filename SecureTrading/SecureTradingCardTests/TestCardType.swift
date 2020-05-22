//
//  TestCardType.swift
//  SecureTradingCardTests
//
//  Created by MCHRZASTEK on 22/05/2020.
//

import XCTest
@testable import SecureTradingCard

class TestCardType: XCTestCase {
    
    func test_isVisa() {
        let expectedType = CardType.visa
        let cardNumbers = KnownCards.visaCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isMasterCard() {
        let expectedType = CardType.mastercard
        let cardNumbers = KnownCards.mastercardCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isMaestro() {
        let expectedType = CardType.maestro
        let cardNumbers = KnownCards.maestroCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isAmex() {
        let expectedType = CardType.amex
        let cardNumbers = KnownCards.amexCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isJCB() {
        let expectedType = CardType.jcb
        let cardNumbers = KnownCards.jcbCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isDiners() {
        let expectedType = CardType.diners
        let cardNumbers = KnownCards.dinerCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isDiscover() {
        let expectedType = CardType.discover
        let cardNumbers = KnownCards.discoverCards
        
        for card in cardNumbers {
            print("Discover: \(card)")
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isPIBA() {
        let expectedType = CardType.piba
        let cardNumbers = KnownCards.pibaCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
