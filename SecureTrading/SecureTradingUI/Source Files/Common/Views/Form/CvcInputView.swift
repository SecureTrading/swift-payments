//
//  CVCInputView.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCard
#endif
import UIKit

@objc public final class CvcInputView: DefaultSecureFormInputView {
    // MARK: Private Properties

    private var expectedInputLength: Int {
        return cardType.securityCodeLength
    }

    // MARK: Public Properties

    @objc public var cardType = CardType.unknown {
        didSet {
            placeholder = expectedInputLength == 3 ? Localizable.CvcInputView.placeholder3.text : Localizable.CvcInputView.placeholder4.text
        }
    }

    @objc public var cvc: String {
        return text ?? .empty
    }

    @objc public override var isInputValid: Bool {
        if !CardValidator.isCVCRequired(for: cardType) {
            return true
        }

        return CardValidator.isCVCValid(cvc: cvc, cardType: cardType)
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    @objc public override init() {
        super.init()
    }

    required init?(coder argument: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CvcInputView {
    /// - SeeAlso: SecureFormInputView.setupProperties
    override func setupProperties() {
        super.setupProperties()

        title = Localizable.CvcInputView.title.text
        placeholder = expectedInputLength == 3 ? Localizable.CvcInputView.placeholder3.text : Localizable.CvcInputView.placeholder4.text
        error = Localizable.CvcInputView.error.text

        keyboardType = .numberPad

        isSecuredTextEntry = true

        textFieldTextAligment = .center

        textFieldImage = UIImage(named: "cvc", in: Bundle(for: CvcInputView.self), compatibleWith: nil)
    }
}

// MARK: TextField delegate

extension CvcInputView {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: textField.text ?? .empty).replacingCharacters(in: range, with: string)

        if !newText.isEmpty, !newText.isNumeric() {
            return false
        }

        let hasOverflow = newText.count > expectedInputLength
        let index = hasOverflow ?
            newText.index(newText.startIndex, offsetBy: expectedInputLength) :
            newText.index(newText.startIndex, offsetBy: newText.count)
        let currentTextFieldText = String(newText[..<index])

        textField.text = currentTextFieldText

        if isInputValid {
            showHideError(show: false)
        }

        return false
    }
}

private extension Localizable {
    enum CvcInputView: String, Localized {
        case title
        case placeholder3
        case placeholder4
        case error
    }
}
