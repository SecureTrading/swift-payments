//
//  CardType.swift
//  SecureTradingCard
//

import Foundation

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
