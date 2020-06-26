//
//  Card.swift
//  SecureTradingUI
//

import Foundation

@objc public class Card: NSObject {
    @objc public let cardNumber: CardNumber?

    @objc public let securityCode: CVC?

    @objc public let expiryDate: ExpiryDate?

    @objc public var cardTypeContainer: CardTypeContainer

    @objc public var cardType: CardType {
        return CardValidator.cardType(for: cardNumber?.rawValue ?? .empty, cardTypes: cardTypeContainer.cardTypes)
    }

    @objc public init(cardNumber: CardNumber?, securityCode: CVC?, expiryDate: ExpiryDate?, cardTypeContainer: CardTypeContainer = CardTypeContainer(cardTypes: CardType.allCases)) {
        self.cardNumber = cardNumber
        self.securityCode = securityCode
        self.expiryDate = expiryDate
        self.cardTypeContainer = cardTypeContainer
    }
}
