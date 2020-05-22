//
//  CardType.swift
//  SecureTradingCard
//

import Foundation

extension String {
    var onlyDigits: String {
        return self.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
    }
}
extension CardType: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .visa: return "Visa"
        case .mastercard: return "MasterCard"
        case .amex: return "American Express"
        case .maestro: return "Maestro"
        case .discover: return "Discover"
        case .diners: return "Diners Club"
        case .jcb: return "JCB"
        case .astropay: return "AstroPay"
        case .piba:  return "PIBA"
        case .unknown: return "Unknown card"
        }
    }
}
enum CardType: CaseIterable {
    case visa
    case mastercard
    case amex
    case maestro
    case discover
    case diners
    case jcb
    case astropay
    case piba // Premier Inn Business Account
    case unknown
    
    var iin: [ClosedRange<Int>] {
        // https://www.barclaycard.co.uk/business/files/BIN-Rules-UK.pdf
        switch self {
        case .visa:             return [400000...499999]
        case .mastercard:       return [510000...559999,
                                        222100...272099]
        case .amex:             return [340000...349999,
                                        370000...379999]
        case .maestro:          return [500000...509999,
                                        560000...699999]
        case .discover:         return [601100...601199,
                                        622126...622925,
                                        624000...626999,
                                        628200...628899,
                                        640000...659999]
        case .diners:           return [300000...305999,
                                        309500...309599,
                                        380000...399999,
                                        360000...369999]
        case .jcb:              return [352800...358999]
        case .astropay:         return [117500...117599,
                                        180100...180199]
        case .piba:             return [308950...308950]
        case .unknown:          return [0...1]
        }
    }
    
    var inputMask: String {
        switch self {
        // 4-6-5
        case .amex:   return "#### ###### #####"
        // 4-6-4
        case .diners: return "#### ###### ####"
        // 4-4-4-4
        default:      return "#### #### #### ####"
        }
    }
    
    var securityCodeLength: Int {
        switch self {
        case .amex: return 4
        case .piba: return 0
        default:    return 3
        }
    }
}

/// Methods for validating card data
class CardValidator {
    /// Returns card type for given card number
    ///
    /// - Parameter number: card number
    /// - Returns: CardType
    static func cardType(for number: String) -> CardType {
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
        var options: Set<CardType> = []
        
        // Iterates throught all card types and their IIN ranges
        for issuer in CardType.allCases {
            for range in issuer.iin {
                if range.contains(inputIin) {
                    options.insert(issuer)
                }
            }
        }
        if options.count == 1 {
            return options.first!
        }
        return CardType.unknown
    }
    
    /// Checks whether card number is valid by evaluating it with Luhn algorithm
    /// - Parameter cardNumber: non-digit characters are skipped
    /// - Returns: true if card number is valid
    static func isCardNumberLuhnCompliant(cardNumber: String) -> Bool {
        let parsedCardNumber = cardNumber.onlyDigits
        
        // The Luhn Algorythm
        return parsedCardNumber.reversed().enumerated().map({
            let digit = Int(String($0.element))!
            let isEven = $0.offset % 2 == 0
            return isEven ? digit : digit == 9 ? 9 : digit * 2 % 9
        }).reduce(0, +) % 10 == 0
    }
}


extension Array {
    func getIfExists(at index: Int) -> Element? {
        guard (0..<self.count).contains(index) else { return nil }
        return self[index]
    }
}
func formatCardNumberWithMask(number: String) -> String {
    let cardIssuer = CardValidator.cardType(for: number)
    print(cardIssuer)
    let inputMask = cardIssuer.inputMask
    let cardNumber = Array(number)
    var maskedNumber = ""
    var symbolIndex = 0
    for symbol in inputMask {
        if symbol == "#" {
            if let a = cardNumber.getIfExists(at: symbolIndex) {
                maskedNumber += String(a)
                symbolIndex += 1
            }
        } else {
            maskedNumber += String(symbol)
        }
    }
    maskedNumber.append(contentsOf: cardNumber[symbolIndex...])
    return maskedNumber
}

func ck(number: String) {
    guard number.isEmpty == false else { return }
    print(number, formatCardNumberWithMask(number: number))
    ck(number: String(number.dropLast()))
}


