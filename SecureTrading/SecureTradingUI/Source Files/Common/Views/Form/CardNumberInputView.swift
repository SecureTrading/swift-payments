//
//  CardNumberInputVIew.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCard
#endif
import UIKit

@objc public protocol CardNumberInputViewDelegate {
    /// Called when the user enters a valid card number.
    /// - Parameter cardNumberInputView: The `CardNumberInputView` that was used to enter the card number.
    func cardNumberInputViewDidComplete(_ cardNumberInputView: CardNumberInputView)

    ///  Called when the user has changed the text in `CardNumberInputView`.
    /// - Parameter cardNumberInputView: `CardNumberInputView`, whose text has been changed.
    func cardNumberInputViewDidChangeText(_ cardNumberInputView: CardNumberInputView)
}

@objc public final class CardNumberInputView: DefaultSecureFormInputView {
    // MARK: Private Properties

    private var cardNumberFormat: CardNumberFormat {
        return CardNumberFormat(cardTypeContainer: cardTypeContainer, separator: cardNumberSeparator)
    }

    // MARK: Public Properties

    @objc public weak var cardNumberInputViewDelegate: CardNumberInputViewDelegate?

    @objc public var cardTypeContainer: CardTypeContainer

    @objc public var cardNumberSeparator: String

    @objc public var cardNumber: CardNumber {
        let textFieldTextWithoutSeparators = cardNumberFormat.removeSeparator(cardNumber: text ?? .empty)
        return CardNumber(rawValue: textFieldTextWithoutSeparators)
    }

    @objc public var cardType: CardType {
        return CardValidator.cardType(for: cardNumber.rawValue, cardTypes: cardTypeContainer.cardTypes)
    }

    @objc public var isCVCRequired: Bool {
        return CardValidator.isCVCRequired(for: cardType)
    }

    @objc public override var isInputValid: Bool {
        let cardType = CardValidator.cardType(for: cardNumber.rawValue, cardTypes: cardTypeContainer.cardTypes)
        return CardValidator.cardNumberHasValidLength(cardNumber: cardNumber.rawValue, card: cardType) && CardValidator.isCardNumberLuhnCompliant(cardNumber: cardNumber.rawValue)
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - cardTypeContainer: A card type container that is used to access accepted card types.
    ///   - cardNumberSeparator: A separator that is used to separate different groups of the card number.
    @objc public init(cardTypeContainer: CardTypeContainer = CardTypeContainer(cardTypes: CardType.allCases), cardNumberSeparator: String = .space) {
        self.cardTypeContainer = cardTypeContainer
        self.cardNumberSeparator = cardNumberSeparator
        super.init()
    }

    required init?(coder argument: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    private func showCardImage() {
        let cardType = CardValidator.cardType(for: cardNumber.rawValue, cardTypes: cardTypeContainer.cardTypes)
        let cardTypeImage = cardType.logo

        textFieldImage = cardTypeImage
    }
}

extension CardNumberInputView {
    /// - SeeAlso: SecureFormInputView.setupProperties
    override func setupProperties() {
        super.setupProperties()

        title = Localizable.CardNumberInputView.title.text
        placeholder = Localizable.CardNumberInputView.placeholder.text
        error = Localizable.CardNumberInputView.error.text

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

        if !newTextWithoutSeparators.isEmpty, !newTextWithoutSeparators.isNumeric {
            return false
        }

        let isOldValid = isInputValid

        let parsedCardNumber = CardNumber(rawValue: newTextWithoutSeparators).rawValue
        let parsedCardType = CardValidator.cardType(for: parsedCardNumber, cardTypes: cardTypeContainer.cardTypes)
        let isNewValid = CardValidator.cardNumberHasValidLength(cardNumber: parsedCardNumber, card: parsedCardType) && CardValidator.isCardNumberLuhnCompliant(cardNumber: parsedCardNumber)

        let isNewNumberTooLong = CardValidator.isNumberTooLong(cardNumber: parsedCardNumber, card: CardValidator.cardType(for: parsedCardNumber, cardTypes: cardTypeContainer.cardTypes))

        if !isNewNumberTooLong {
            cardNumberFormat.addSeparators(range: range, inTextField: textField, replaceWith: string)
            showCardImage()
            cardNumberInputViewDelegate?.cardNumberInputViewDidChangeText(self)
        } else if isOldValid {
            showHideError(show: false)
            cardNumberInputViewDelegate?.cardNumberInputViewDidComplete(self)
            return false
        }

        if isNewValid {
            showHideError(show: false)
            cardNumberInputViewDelegate?.cardNumberInputViewDidComplete(self)
        }

        return false
    }
}

private extension Localizable {
    enum CardNumberInputView: String, Localized {
        case title
        case placeholder
        case error
    }
}
