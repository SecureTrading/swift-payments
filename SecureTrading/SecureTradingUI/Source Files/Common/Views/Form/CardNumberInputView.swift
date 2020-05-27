//
//  CardNumberInputVIew.swift
//  SecureTradingUI
//

import SecureTradingCard
import UIKit

@objc public final class CardNumberInputView: SecureFormInputView {
    // MARK: Public Properties

    @objc public var cardNumberSeparator: String = .space

    public var cardTypeContainer: CardTypeContainer = CardTypeContainer(cardTypes: CardType.allCases)

    @objc public override var inputIsValid: Bool {
        let cardType = CardValidator.cardType(for: cardNumber.rawValue, cardTypes: cardTypeContainer.cardTypes)
        return CardValidator.cardNumberHasValidLength(cardNumber: cardNumber.rawValue, card: cardType) && CardValidator.isCardNumberLuhnCompliant(cardNumber: cardNumber.rawValue)
    }

    // MARK: Private Properties

    private var cardNumber: CardNumber {
        let textFieldTextWithoutSeparators = cardNumberFormat.removeSeparator(cardNumber: text ?? .empty)
        return CardNumber(rawValue: textFieldTextWithoutSeparators)
    }

    private var cardNumberFormat: CardNumberFormat {
        return CardNumberFormat(cardTypeContainer: cardTypeContainer, separator: cardNumberSeparator)
    }

    // MARK: Functions

    private func showCardImage() {
        let cardType = CardValidator.cardType(for: cardNumber.rawValue)
        let cardTypeImage = cardType.logo

        textFieldImage = cardTypeImage
    }
}

extension CardNumberInputView {
    /// - SeeAlso: SecureFormInputView.setupProperties
    override func setupProperties() {
        super.setupProperties()

        title = "Card number"
        placeholder = "0000 0000 0000 0000"
        error = "bad card number"

        keyboardType = .numberPad

        showCardImage()
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

        let isOldValid = inputIsValid

        let parsedCardNumber = CardNumber(rawValue: newTextWithoutSeparators).rawValue
        let parsedCardType = CardValidator.cardType(for: parsedCardNumber, cardTypes: cardTypeContainer.cardTypes)
        let isNewValid = CardValidator.cardNumberHasValidLength(cardNumber: parsedCardNumber, card: parsedCardType) && CardValidator.isCardNumberLuhnCompliant(cardNumber: parsedCardNumber)

        let isNewNumberTooLong = CardValidator.isNumberTooLong(cardNumber: parsedCardNumber, card: CardValidator.cardType(for: parsedCardNumber, cardTypes: cardTypeContainer.cardTypes))

        if !isNewNumberTooLong {
            cardNumberFormat.addSeparators(range: range, inTextField: textField, replaceWith: string)
            showCardImage()
        } else if isOldValid {
            showHideError(show: false)
            return false
        }

        if isNewValid {
            showHideError(show: false)
        }

        return false
    }
}
