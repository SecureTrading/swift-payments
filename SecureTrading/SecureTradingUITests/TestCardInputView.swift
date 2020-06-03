//
//  TestCardInputView.swift
//  SecureTradingUITests
//

import XCTest
@testable import SecureTradingUI
@testable import SecureTradingCard

class TestCardInputView: XCTestCase {
    
    func test_cardInputInit() {
        let cardTypeContainer = CardTypeContainer(cardTypes: [CardType.amex])
        let cardSeparator = "#"
        let sut = CardNumberInputView(cardTypeContainer: cardTypeContainer, cardNumberSeparator: cardSeparator)
        XCTAssertEqual(sut.cardTypeContainer, cardTypeContainer)
        XCTAssertEqual(sut.cardNumberSeparator, cardSeparator)
    }
    func test_cvcNotRequiredForPiba() {
        let cardTypeContainer = CardTypeContainer(cardTypes: [CardType.piba])
        let cardSeparator = "#"
        let sut = CardNumberInputView(cardTypeContainer: cardTypeContainer, cardNumberSeparator: cardSeparator)
        sut.text = KnownMaskedCards.pibaCards.first!
        XCTAssertFalse(sut.isCVCRequired)
    }
    func test_cvcRequiredForAmex() {
        let cardTypeContainer = CardTypeContainer(cardTypes: [CardType.amex])
        let cardSeparator = "#"
        let sut = CardNumberInputView(cardTypeContainer: cardTypeContainer, cardNumberSeparator: cardSeparator)
        sut.text = KnownMaskedCards.amexCards.first!
        XCTAssertTrue(sut.isCVCRequired)
    }
    func test_invalidFor16DigitsAmex() {
        let cardTypeContainer = CardTypeContainer(cardTypes: [CardType.amex])
        let cardSeparator = "#"
        let sut = CardNumberInputView(cardTypeContainer: cardTypeContainer, cardNumberSeparator: cardSeparator)
        sut.text = KnownMaskedCards.amexCards.first! + "0"
        XCTAssertFalse(sut.isInputValid)
    }
    func test_invalidFor14DigitsAmex() {
        let cardTypeContainer = CardTypeContainer(cardTypes: [CardType.amex])
        let cardSeparator = "#"
        let sut = CardNumberInputView(cardTypeContainer: cardTypeContainer, cardNumberSeparator: cardSeparator)
        sut.text = String(KnownMaskedCards.amexCards.first!.dropLast())
        XCTAssertFalse(sut.isInputValid)
    }
    func test_validForCorrectAmex() {
        let cardTypeContainer = CardTypeContainer(cardTypes: [CardType.amex])
        let cardSeparator = "#"
        let sut = CardNumberInputView(cardTypeContainer: cardTypeContainer, cardNumberSeparator: cardSeparator)
        sut.text = KnownMaskedCards.amexCards.first!
        XCTAssertTrue(sut.isInputValid)
    }
}
