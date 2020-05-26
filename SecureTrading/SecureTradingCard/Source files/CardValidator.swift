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
    /// - Returns: CardType
    public static func cardType(for number: String) -> CardType {
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
        for issuer in CardType.allCases {
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
        guard let yearComponent = Int(components.last!) else { return false }
        guard (1...12).contains(monthComponent) else { return false }
        let expirationDatecomponents = DateComponents(year: yearComponent, month: monthComponent)
        guard let expirationDate = Calendar.current.date(from: expirationDatecomponents) else { return false }
        return !expirationDate.isEarlierThanCurrentMonth()
    }
}

fileprivate extension Date {
    /// Checks if date is earlier than current date, compares only month and year components
    /// - Returns: if date is in past
    func isEarlierThanCurrentMonth() -> Bool {
        let now = Date()
        let currentComponents = Calendar.current.dateComponents([.year, .month], from: now)
        guard let nowFromComponents = Calendar.current.date(from: currentComponents) else { return false }
        return self < nowFromComponents
    }
}
