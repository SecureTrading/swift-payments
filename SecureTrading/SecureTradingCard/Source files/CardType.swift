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

enum CardType: CustomDebugStringConvertible {
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
    
    
    // Do not depend on this solution in cases other than
    // displaying card issuer logo
    // bin's are frequently updated
//    var regex: String? {
//        switch self {
//        case .visa: return "^4[0-9]{12}(?:[0-9]{3,6})?$"
//        case .mastercard: return "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}"
//        case .amex: return "^3[47][0-9]{13}"
//        case .maestro: return "^(5018|5020|5038|6304|6759|6761|6763)[0-9]{8,15}"
//        case .diners: return "^3(?:0[0-5]|[68][0-9])[0-9]{11}"
//        case .discover:  return "^6(?:011|5[0-9]{2})[0-9]{12}"
//        case .jcb: return "^35\\d{14,17}"
//        case .piba: return ""
//        case .astropay, .unknown: return nil
//        }
//    }
    
    var inputMask: String {
        switch self {
            // 4-4-4-4
            case .visa, .mastercard, .discover, .jcb, .astropay: return "#### #### #### ####"
            // 4-6-5
            case .amex: return "#### ###### #####"
            case .maestro: return "#### #### #### ####"
            // 4-6-4
            case .diners: return "#### ###### ####"
            case .unknown: return ""
        case .piba: return ""
        }
    }
    
    var securityCodeLength: Int {
        switch self {
        case .amex: return 4
        default: return 3
        }
    }
    
    static var all: [CardType] {
        return [.visa, .mastercard, .amex, .maestro, .discover, .diners, .jcb, .astropay, .piba]
    }
}

func cardType(for number: String) -> CardType {
    guard number.count > 1 || number.hasPrefix("4") else { return CardType.unknown }
    var i: String = number
    while i.count < 6 {
        i += "0"
    }
    let a = String(Array(i)[...5])
    guard let inputIin = Int(a) else { return CardType.unknown }
    var options: Set<CardType> = []
    for issuer in CardType.all {
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

enum CreditCardLayout {
    enum Face {
        case front
        case back
    }
}

//
//func cardIssued(basedOn cardNumber: String) -> CardIssuer {
//    // remove non - numberic characters
//    return ci(number: cardNumber)
//    let parsedCardNumber = cardNumber.onlyDigits
//
//    // filter all card issuers and return one that matches regex pattern
//    let brand = CardIssuer.all.first { (issuer) -> Bool in
//        guard let cardRegex = issuer.regex else { return false }
//        return parsedCardNumber.range(of: cardRegex, options: .regularExpression, range: nil, locale: nil) == nil ? false : true
//        }
//    return brand ?? .unknown
//}

// check if checksum for card number is valid
func isCardNumberValid(cardNumber: String) -> Bool {
    let parsedCardNumber = cardNumber.onlyDigits

    // The Luhn Algorythm
    return parsedCardNumber.reversed().enumerated().map({
        let digit = Int(String($0.element))!
        let isEven = $0.offset % 2 == 0
        return isEven ? digit : digit == 9 ? 9 : digit * 2 % 9
    }).reduce(0, +) % 10 == 0
}
extension Array {
    func getIfExists(at index: Int) -> Element? {
        guard (0..<self.count).contains(index) else { return nil }
        return self[index]
    }
}
func formatCardNumberWithMask(number: String) -> String {
    let cardIssuer = cardType(for: number)
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

// VISA:
let visaCards = [
    "4916477287051663",
    "4219528169189312",
    "4539372795292001367"
]
//cardIssued(basedOn: "4916477287")
let mastercardCards = [
    "2720991229108712",
    "5319765425806323",
    "5133684126825306"
]
let amexCards = [
    "342009335615660",
    "375791692744809",
    "370780566358312"
]
let discoverCards = [
    "6011934210819607",
    "6011061237448028",
    "6011311934396924735"
]
let jcbCards = [
    "3532647394687577",
    "3530904427983883",
    "3530785855150495506"
]
let dinerCards = [
    "30191333657196",
    "30391588549102",
    "30416520198062",
    "36983926195368",
    "36636816339062",
    "36902641495069"
]
let maestroCards = [
    "5020232406609127",
    "6759055161671239",
    "5018379211626087"
]
let allCards = [visaCards, mastercardCards, amexCards, discoverCards, jcbCards, dinerCards, maestroCards].flatMap{ $0 }

//for card in allCards {
//    //print("\(card) \t-> \(cardIssued(basedOn: card)) - valid:\t \(isCardNumberValid(cardNumber: card))\t \(formatCardNumberWithMask(number: card))")
//}


