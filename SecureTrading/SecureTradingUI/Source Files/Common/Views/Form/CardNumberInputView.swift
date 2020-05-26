//
//  CardNumberInputVIew.swift
//  SecureTradingUI
//

import UIKit

@objc public final class CardNumberInputView: SecureFormInputView {

    // MARK: Public Properties

    public var cardNumberSeparator: String = .space

    public var cardNumber: CardNumber {
        let textFieldTextWithoutSeparators = cardNumberFormat.removeSeparator(cardNumber: text ?? .empty)
        return CardNumber(rawValue: textFieldTextWithoutSeparators)
    }

    public var cardTypeContainer: CardTypeContainer = CardTypeContainer()

    // MARK: Private Properties

    private var cardNumberFormat: CardNumberFormat {
        return CardNumberFormat(cardTypeContainer: cardTypeContainer, separator: cardNumberSeparator)
    }
}

// MARK: TextField delegate

extension CardNumberInputView {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldTextWithSeparators = NSString(string: textField.text ?? .empty)
        let newTextWithSeparators = textFieldTextWithSeparators.replacingCharacters(in: range, with: string)
        let newTextWithoutSeparators = cardNumberFormat.removeSeparator(cardNumber: newTextWithSeparators)

        if !newTextWithoutSeparators.isEmpty, !newTextWithoutSeparators.isNumeric() {
            return false
        }

        cardNumberFormat.addSeparators(range: range, inTextField: textField, replaceWith: string)

        return false
    }
}
