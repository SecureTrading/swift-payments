//
//  TestCardType.swift
//  SecureTradingCardTests
//

import XCTest
@testable import SecureTradingCard

class TestCardType: XCTestCase {
    
    // MARK: - Test card types
    func test_isUnknownForSingleDigit() {
        // if card number starts with other digit that 4
        // then the card type cannot be determined
        // more digits are needed
        let expectedType = CardType.unknown
        let cardNumber = "5"
        XCTAssertEqual(expectedType, CardValidator.cardType(for: cardNumber))
    }
    func test_isUnknownForNonDigit() {
        // if card number starts with other digit that 4
        // then the card type cannot be determined
        // more digits are needed
        let expectedType = CardType.unknown
        let cardNumber = "5@dsa"
        XCTAssertEqual(expectedType, CardValidator.cardType(for: cardNumber))
    }
    func test_isUnknown() {
       let expectedType = CardType.unknown
        let cardNumbers = KnownCards.invalidCards
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isVisa() {
        let expectedType = CardType.visa
        let cardNumbers = KnownCards.visaCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isVisaIfStartsWith4() {
        let expectedType = CardType.visa
        let cardNumber = "4"
        XCTAssertEqual(expectedType, CardValidator.cardType(for: cardNumber))
        
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
    
    // MARK: - Test security code length
    
    func test_amexCCVis4() {
        let card = CardType.amex
        XCTAssertEqual(card.securityCodeLength, 4)
    }
    
    func test_pibaCCVis0() {
        let card = CardType.piba
        XCTAssertEqual(card.securityCodeLength, 0)
    }
    
    func test_visaCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_mastercardCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_maestroCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_discoverCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_dinersCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_jcbCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    
    
    // MARK: Test dependant extensions
    func test_removeClosedRangeFromClosedRange() {
        let givenRange: ClosedRange<Int> = 1...10
        let rangeToRemove: ClosedRange<Int> = 3...8
        let expectedRanges: [ClosedRange<Int>] = [1...2, 9...10]
        
        let sut = givenRange.remove(range: rangeToRemove)
        XCTAssertTrue(sut.count == 2)
        XCTAssertTrue(sut.contains(expectedRanges[0]))
        XCTAssertTrue(sut.contains(expectedRanges[1]))
    }
    func test_removeClosedRangeFromClosedRange_InvalidLowerbound() {
        let givenRange: ClosedRange<Int> = 1...10
        let rangeToRemove: ClosedRange<Int> = 0...8
        
        let sut = givenRange.remove(range: rangeToRemove)
        XCTAssertTrue(sut.count == 0)
    }
    func test_removeClosedRangeFromClosedRange_InvalidUpperbound() {
        let givenRange: ClosedRange<Int> = 1...10
        let rangeToRemove: ClosedRange<Int> = 3...50
        let expectedRange: ClosedRange<Int> = 1...2
        
        let sut = givenRange.remove(range: rangeToRemove)
        XCTAssertTrue(sut.count == 1)
        XCTAssertTrue(sut.contains(expectedRange))
    }
    func test_removeClosedRangeFromClosedRange_InvalidBound() {
        let givenRange: ClosedRange<Int> = 1...10
        let rangeToRemove: ClosedRange<Int> = 0...50
        
        let sut = givenRange.remove(range: rangeToRemove)
        XCTAssertTrue(sut.count == 0)
    }
}
