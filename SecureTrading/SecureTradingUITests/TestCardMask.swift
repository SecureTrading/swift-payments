//
//  TestCardMask.swift
//  SecureTradingUITests
//

@testable import SecureTradingUI
@testable import SecureTradingCard
import XCTest

class TestCardMask: XCTestCase {
    private var sut: CardNumberFormat!

    override func setUp() {
        super.setUp()
        sut = CardNumberFormat(cardTypeContainer: CardTypeContainer(cardTypes: CardType.allCases))
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: Test Card Masks

    func check(card: String) {
        let unformattedCard = sut.removeSeparator(cardNumber: card)
        XCTAssertTrue(!unformattedCard.contains(sut.separator))
        let formattedCard = sut.addSeparators(cardNumber: unformattedCard)
        let isFormattingValid = card == formattedCard
        XCTAssertTrue(isFormattingValid)
    }

    func test_isVisaCardMaskValid() {
        let maskedCardNumbers = KnownMaskedCards.visaCards
        for card in maskedCardNumbers {
            check(card: card)
        }
    }

    func test_isMastercardCardMaskValid() {
        let maskedCardNumbers = KnownMaskedCards.mastercardCards
        for card in maskedCardNumbers {
            check(card: card)
        }
    }

    func test_isMaestroCardMaskValid() {
        let maskedCardNumbers = KnownMaskedCards.maestroCards
        for card in maskedCardNumbers {
            check(card: card)
        }
    }

    func test_isAmexCardMaskValid() {
        let maskedCardNumbers = KnownMaskedCards.amexCards
        for card in maskedCardNumbers {
            check(card: card)
        }
    }

    func test_isDiscoverCardMaskValid() {
        let maskedCardNumbers = KnownMaskedCards.discoverCards
        for card in maskedCardNumbers {
            check(card: card)
        }
    }

    func test_isDinersCardMaskValid() {
        let maskedCardNumbers = KnownMaskedCards.dinerCards
        for card in maskedCardNumbers {
            check(card: card)
        }
    }

    func test_isJCBCardMaskValid() {
        let maskedCardNumbers = KnownMaskedCards.jcbCards
        for card in maskedCardNumbers {
            check(card: card)
        }
    }

    func test_isPIBACardMaskValid() {
        let maskedCardNumbers = KnownMaskedCards.pibaCards
        for card in maskedCardNumbers {
            check(card: card)
        }
    }

    func test_isUnknownCardMaskInvalid() {
        let maskedCardNumbers = ["1212 1212 1221 1212 1234 5454 5353", "1212 1212 1221 1212 1234 545"]
        for card in maskedCardNumbers {
            check(card: card)
        }
    }
}
