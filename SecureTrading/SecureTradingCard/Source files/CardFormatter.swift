//
//  CardFormatter.swift
//  SecureTradingCard
//

import Foundation

// TODO:
// Responsible for formatting card number

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
