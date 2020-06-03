//
//  Card.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 03/06/2020.
//

import Foundation

@objc public class Card: NSObject {
    @objc public let cardNumber: CardNumber

    @objc public let verificationCode: CVC

    @objc public let expiryDate: ExpiryDate

    @objc public static func create(number: String, cvc: String, expiryDate: String) -> Card {
        let cardNumber = CardNumber(rawValue: number)
        let cardCVC = CVC(rawValue: cvc)
        let cardExpiryDate = ExpiryDate(rawValue: expiryDate)

        return Card(number: cardNumber, cvc: cardCVC, expiryDate: cardExpiryDate)
    }

    @objc public init(number: CardNumber, cvc: CVC, expiryDate: ExpiryDate) {
        self.cardNumber = number
        self.verificationCode = cvc
        self.expiryDate = expiryDate
    }
}
