//
//  CardValidator.swift
//  SecureTradingCard
//

import Foundation

/// Methods for validating card data
public class CardValidator {
    /// Returns card type for given card number
    ///
    /// - Parameter number: card number
    /// - Parameter cardTypes: search card collection
    /// - Returns: CardType
    public static func cardType(for number: String, cardTypes: [CardType] = CardType.allCases) -> CardType {
        var cardNumber = number.onlyDigits
        // Only Visa starts with 4
        guard cardNumber.count > 1 || cardNumber.hasPrefix("4") else { return CardType.unknown }

        // if input is shorter than 6 characters
        // fill missing characters with '0'
        while cardNumber.count < 6 {
            cardNumber += "0"
        }

        // limits to 6 digits if longer value is provided
        cardNumber = String(cardNumber.prefix(6))
        guard let inputIin = Int(cardNumber) else { return CardType.unknown }

        // Iterates throught all card types and their IIN ranges
        for issuer in cardTypes {
            for range in issuer.iin {
                if range.contains(inputIin) {
                    return issuer
                }
            }
        }
        return CardType.unknown
    }

    /// Checks whether card number is valid by evaluating it with Luhn algorithm
    /// - Parameter cardNumber: non-digit characters are skipped
    /// - Returns: true if card number is valid
    public static func isCardNumberLuhnCompliant(cardNumber: String) -> Bool {
        let parsedCardNumber = cardNumber.onlyDigits

        // The Luhn Algorythm
        return parsedCardNumber.reversed().enumerated().map({
            let digit = Int(String($0.element))!
            let isEven = $0.offset % 2 == 0
            return isEven ? digit : digit == 9 ? 9 : digit * 2 % 9
        }).reduce(0, +) % 10 == 0
    }

    /// Check if provided card numbe has valid length
    /// - Parameters:
    ///   - number: card number, function also parses to digits-only
    ///   - type: card type to check against for
    /// - Returns: is card length valid for given card type
    public static func cardNumberHasValidLength(cardNumber number: String, card type: CardType) -> Bool {
        let cardDigits = number.onlyDigits
        let possibleLengths = type.validNumberLengths
        let cardNumberLength = cardDigits.count
        return possibleLengths.contains(cardNumberLength)
    }

    /// checks that the card number is too long
    /// - Parameters:
    ///   - number: card number, function also parses to digits-only
    ///   - type: card type to check against for
    /// - Returns: is the card number too long
    public static func isNumberTooLong(cardNumber number: String, card type: CardType) -> Bool {
        let cardDigits = number.onlyDigits
        let maxLength = type.validNumberLengths.max()
        let cardNumberLength = cardDigits.count
        return cardNumberLength > maxLength ?? 0
    }

    /// Checks if expiration date is valid and not in the past
    /// - Parameters:
    ///   - code: expiration date string
    ///   - separator: optional separator if one used is different than "/"
    /// - Returns: Expiration date is valid
    public static func isExpirationDateValid(date: String, separator: String? = nil) -> Bool {
        let dateSeparator = separator ?? "/"
        let components = date.components(separatedBy: dateSeparator)
        guard components.count == 2 else { return false }
        guard let monthComponent = Int(components.first!) else { return false }
        guard var yearComponent = Int(components.last!) else { return false }
        // Handle short year notation 22 instead of 2022
        if yearComponent < 100 {
            yearComponent += 2000
        }

        guard (1...12).contains(monthComponent) else { return false }
        let expirationDatecomponents = DateComponents(year: yearComponent, month: monthComponent)
        guard let expirationDate = Calendar.current.date(from: expirationDatecomponents) else { return false }
        return !expirationDate.isEarlierThanCurrentMonth()
    }

    /// Checks if security code is valid
    /// - Parameters:
    ///   - cvc: string containig the code
    ///   - cardType: card type against which the code will be checked
    /// - Returns: is the code valid
    public static func isCVCValid(cvc: String, cardType: CardType) -> Bool {
        let parsedCvc = cvc.onlyDigits

        // Handles case where 3 digits are required but input is like so: 1a2b3b
        guard parsedCvc.count == cvc.count else { return false }
        return parsedCvc.count == cardType.securityCodeLength
    }

    /// Checks if security code is required for given card type
    /// - Parameter cardType: card type against which the requirements will be checked
    /// - Returns: is CVC required
    public static func isCVCRequired(for cardType: CardType) -> Bool {
        return cardType.securityCodeLength > 0
    }
}
