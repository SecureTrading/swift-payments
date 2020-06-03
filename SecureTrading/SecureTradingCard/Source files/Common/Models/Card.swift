//
//  Card.swift
//  SecureTradingUI
//

import Foundation

@objc public class Card: NSObject {
    @objc public let cardNumber: CardNumber

    @objc public let securityCode: CVC?

    @objc public let expiryDate: ExpiryDate

    @objc public static func create(cardNumber: String, securityCode: String?, expiryDate: String) -> Card {
        let number = CardNumber(rawValue: cardNumber)
        let cvc = CVC(rawValue: securityCode ?? "")
        let cardExpiryDate = ExpiryDate(rawValue: expiryDate)

        return Card(cardNumber: number, securityCode: cvc, expiryDate: cardExpiryDate)
    }

    @objc public init(cardNumber: CardNumber, securityCode: CVC?, expiryDate: ExpiryDate) {
        self.cardNumber = cardNumber
        self.securityCode = securityCode
        self.expiryDate = expiryDate
    }
}
