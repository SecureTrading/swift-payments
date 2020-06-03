//
//  TestCardTypeContainer.swift
//  SecureTradingUITests
//

import XCTest
@testable import SecureTradingUI
@testable import SecureTradingCard

class TestCardTypeContainer: XCTestCase {
    
    func test_InitWithCardTypes() {
        let cardTypes = CardType.allCases
        let sut = CardTypeContainer(cardTypes: cardTypes)
        let diff = Set(cardTypes).subtracting(sut.cardTypes)
        XCTAssertEqual(sut.cardTypes.count, cardTypes.count)
        XCTAssertEqual(diff.count, 0)
    }
    func test_InitWithValidID() {
        let cardTypes = CardType.allCases
        let sut = CardTypeContainer(cardTypes: cardTypes.map { $0.rawValue })
        let diff = Set(cardTypes).subtracting(sut.cardTypes)
        XCTAssertEqual(sut.cardTypes.count, cardTypes.count)
        XCTAssertEqual(diff.count, 0)
    }
    func test_InitWithInvalidID() {
        let sut = CardTypeContainer(cardTypes: [100, 200, 300, 400])
        XCTAssertEqual(sut.cardTypes.count, 0)
    }
    func test_addCard() {
        let sut = CardTypeContainer(cardTypes: [])
        sut.add(cardType: CardType.visa)
        XCTAssertEqual(sut.cardTypes.count, 1)
        XCTAssertTrue(sut.cardTypes.contains(CardType.visa))
    }
    func test_addTheSameCardDoesntDuplicate() {
        let sut = CardTypeContainer(cardTypes: [])
        sut.add(cardType: CardType.visa)
        sut.add(cardType: CardType.visa)
        XCTAssertEqual(sut.cardTypes.count, 1)
        XCTAssertTrue(sut.cardTypes.contains(CardType.visa))
    }
    func test_removeCardThatExists() {
        let sut = CardTypeContainer(cardTypes: [CardType.visa])
        sut.remove(cardType: .visa)
        XCTAssertEqual(sut.cardTypes.count, 0)
        XCTAssertFalse(sut.cardTypes.contains(CardType.visa))
    }
    func test_removeCardThatDoesntExists() {
        let sut = CardTypeContainer(cardTypes: [CardType.visa])
        sut.remove(cardType: .amex)
        XCTAssertEqual(sut.cardTypes.count, 1)
        XCTAssertTrue(sut.cardTypes.contains(CardType.visa))
    }
}
