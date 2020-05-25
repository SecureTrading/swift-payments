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
extension ClosedRange where Bound == Int {
    /// Constructs a new array containing ranges that are not in the range of caller
    /// - Parameter subrange: ClosedRange for exclusion
    /// - Returns: Array of CloseRange elements that are not in the range of caller
    func remove(range subrange: ClosedRange<Int>) -> [ClosedRange<Int>] {
        // 1...10 / 3...8 -> [1...2, 9...10]
        guard subrange.lowerBound > self.lowerBound else { return [] }
        let prefix = self.lowerBound...(subrange.lowerBound - 1)
        guard self.upperBound > subrange.upperBound else { return [prefix]}
        let suffix = (subrange.upperBound + 1)...self.upperBound
        return [prefix, suffix]
    }
}
extension Array where Element == ClosedRange<Int> {
    func except(ranges: [Element]) -> [Element]{
        var newRanges: [Element] = []
        var split = false
        // goes throught all ranges and subranges
        // then checks if main range contains dividing range
        // if so, divides main range to exclude subrange
        for mainRange in self.sorted(by: {$0.lowerBound < $1.lowerBound}) {
            let sortedRanges = ranges.sorted{$0.lowerBound < $1.lowerBound}
            for subRange in sortedRanges {
                if mainRange.contains(subRange.lowerBound) {
                    // split
                    let diff = mainRange.remove(range: subRange)
                    newRanges.append(contentsOf: diff)
                    split = true
                }
            }
            // if range wasn't modified a.k.a splitted
            // then append oryginal range to new array
            if split == false {
                newRanges.append(mainRange)
            }
            split = false
        }
        
        // newRanges array contains ranges that may overlap
        // especially if were divided by multiple ranges
        // 1...10 / [2...5, 7...8] -> [1...1, 6...10, 1...6, 9...10]
        // The loop below checkes elements next to each other and adjust
        // their lower and upper ranges, so at the end it look like this
        // 1...10 / [2...5, 7...8] -> [1...1, 6...6, 9...10]
        
        var normalizedRanges: [Element] = []
        for (index, range) in newRanges.enumerated() {
            if range.upperBound == normalizedRanges.last?.upperBound {
                // skips adding range that has the same upper bound
                // like the previous range
                // comparing to example above, this avoids 1...6 from adding
                continue
            }
            if let next = newRanges.getIfExists(at: index + 1) {
                if range.upperBound > next.upperBound {
                    // modifies range so the upper bound is greater than next range
                    // comparing to example above, this replaces 6...10 -> 6...6
                    let newRange = range.lowerBound...next.upperBound
                    normalizedRanges.append(newRange)
                } else {
                    // nothing to change, add oryginal range
                    normalizedRanges.append(range)
                }
            } else {
                // nothing to change, add oryginal range
                normalizedRanges.append(range)
            }
        }
        return normalizedRanges
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
                                        560000...699999].except(ranges: CardType.discover.iin)
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


