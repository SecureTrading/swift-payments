//
//  CardType.swift
//  SecureTradingUI
//

import Foundation

/// The CardType is a predefined type for different bank cards. An example is "Visa" or "American Express", each with a slightly different format of payment card information.
public protocol CardType {
    /// Name of card type (e.g. Visa, MasterCard, ...)
    var name: String { get }

    /// Card number grouping is used to format the card number when entering the card number in the text field. For example, for Visa card types, this group will look like this: [4,4,4,4]
    var numberGrouping: [Int] { get }

    /// Number of digits expected in the verification code of the card
    var cvcLength: Int { get }

    /// A set of numbers which, when the first digits of the card number are found, indicate the card issuer - Card types are usually identified by the first n digits. According to ISO/IEC 7812
    var identifyingDigits: Set<Int> { get }

    /// checks that it's the same cards
    /// - Parameter cardType: another type of card to check for equality with
    func isEqual(to cardType: CardType) -> Bool
}

extension CardType {
    public func isEqual(to cardType: CardType) -> Bool {
        return cardType.name == self.name
    }

    public var numberGrouping: [Int] {
        return [4, 4, 4, 4]
    }
}
