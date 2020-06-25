//
//  Card.swift
//  SecureTradingUI
//

import Foundation

@objc public class Card: NSObject {
    @objc public let cardNumber: CardNumber?

    @objc public let securityCode: CVC?

    @objc public let expiryDate: ExpiryDate?

    @objc public init(cardNumber: CardNumber?, securityCode: CVC?, expiryDate: ExpiryDate?) {
        self.cardNumber = cardNumber
        self.securityCode = securityCode
        self.expiryDate = expiryDate
    }
}
