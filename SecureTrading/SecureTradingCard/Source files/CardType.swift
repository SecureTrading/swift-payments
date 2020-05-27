//
//  CardType.swift
//  SecureTradingCard
//

import Foundation
import UIKit

public enum CardType: CaseIterable {
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
    
    var validNumberLengths: Set<Int> {
        switch self {
        case .visa:             return [13, 16, 19]
        case .mastercard:       return [16]
        case .amex:             return [15]
        case .maestro:          return [12, 13, 14, 15, 16, 17, 18, 19]
        case .discover:         return [14, 15, 16, 17, 18, 19]
        case .diners:           return [14, 15, 16, 17, 18, 19]
        case .jcb:              return [15, 16, 19]
        case .astropay:         return [16]
        case .piba:             return [19]
        case .unknown:          return [16]
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

    public var numberGrouping: [Int] {
        let stringArray = inputMask.components(separatedBy: String.space)
        return stringArray.map { $0.count }
    }

    var securityCodeLength: Int {
        switch self {
        case .amex: return 4
        case .piba: return 0
        default:    return 3
        }
    }
    
    public var logo: UIImage? {
        switch self {
        case .visa: return image(for: "visa")
        case .mastercard: return image(for: "mastercard")
        case .amex: return image(for: "amex")
        case .maestro: return image(for: "maestro")
        case .discover: return image(for: "discover")
        case .diners: return image(for: "diners")
        case .jcb: return image(for: "jcb")
        case .astropay: return image(for: "astropay")
        case .piba:  return image(for: "piba")
        case .unknown: return image(for: "unknown")
        }
    }
    
    private func image(for name: String) -> UIImage? {
        let imageName = name + "_logo"
        return UIImage(named: imageName, in: Bundle(for: CardValidator.self), compatibleWith: nil)
    }
}

extension CardType: CustomDebugStringConvertible {
    public var debugDescription: String {
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
