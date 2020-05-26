//
//  TestCardNumber.swift
//  SecureTradingCardTests
//

import XCTest
@testable import SecureTradingCard

class TestCardNumber: XCTestCase {
    
    // MARK: Test Card Lengths
    func test_isVisaCardNumberLengthValid() {
        let cardNumbers = KnownCards.visaCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .visa)
            XCTAssertTrue(isValid)
        }
    }
    func test_isMastercardCardNumberLengthValid() {
        let cardNumbers = KnownCards.mastercardCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .mastercard)
            XCTAssertTrue(isValid)
        }
    }
    func test_isMaestroCardNumberLengthValid() {
        let cardNumbers = KnownCards.maestroCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .maestro)
            XCTAssertTrue(isValid)
        }
    }
    func test_isAmexCardNumberLengthValid() {
        let cardNumbers = KnownCards.amexCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .amex)
            XCTAssertTrue(isValid)
        }
    }
    func test_isDiscoverCardNumberLengthValid() {
        let cardNumbers = KnownCards.discoverCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .discover)
            XCTAssertTrue(isValid)
        }
    }
    func test_isDinersCardNumberLengthValid() {
        let cardNumbers = KnownCards.dinerCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .diners)
            XCTAssertTrue(isValid)
        }
    }
    func test_isJCBCardNumberLengthValid() {
        let cardNumbers = KnownCards.jcbCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .jcb)
            XCTAssertTrue(isValid)
        }
    }
    func test_isPIBACardNumberLengthValid() {
        let cardNumbers = KnownCards.pibaCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .piba)
            XCTAssertTrue(isValid)
        }
    }
    func test_isUnknownCardNumberLengthInvalid() {
        let cardNumbers = ["1234", "1212121212211212123454545353"]
        let allCards = CardType.allCases
        for card in allCards {
            for cardNumber in cardNumbers {
                let isValid = CardValidator.cardNumberHasValidLength(cardNumber: cardNumber, card: card)
                XCTAssertFalse(isValid)
            }
        }
    }
    
    // MARK: - Luhn check
    func test_isVisaCardNumberLuhnValid() {
        let cardNumbers = KnownCards.visaCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isMastercardCardNumberLuhnValid() {
        let cardNumbers = KnownCards.mastercardCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isMaestroCardNumberLuhnValid() {
        let cardNumbers = KnownCards.maestroCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isAmexCardNumberLuhnValid() {
        let cardNumbers = KnownCards.amexCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isDiscoverCardNumberLuhnValid() {
        let cardNumbers = KnownCards.discoverCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isDinersCardNumberLuhnValid() {
        let cardNumbers = KnownCards.dinerCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isJCBCardNumberLuhnValid() {
        let cardNumbers = KnownCards.jcbCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isPIBACardNumberLuhnValid() {
        let cardNumbers = KnownCards.pibaCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isUnknownCardNumberLuhnInvalid() {
        let cardNumbers = KnownCards.invalidCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertFalse(isValid)
        }
    }
}
