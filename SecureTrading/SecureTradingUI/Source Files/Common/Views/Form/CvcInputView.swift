//
//  CVCInputView.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCore
import SecureTradingCard
#endif
import UIKit

@objc public final class CvcInputView: DefaultSecureFormInputView, CvcInput {
    // MARK: Private Properties

    private var expectedInputLength: Int {
        return cardType.securityCodeLength
    }

    // MARK: Public Properties

    @objc public var cardType = CardType.unknown {
        didSet {
            placeholder = placeholderForTextField(cardType: cardType, expectedLength: expectedInputLength)
        }
    }

    @objc public var cvc: CVC? {
        guard let text = text, !text.isEmpty else { return nil }
        return CVC(rawValue: text)
    }

    @objc public override var isInputValid: Bool {
        if !CardValidator.isCVCRequired(for: cardType) {
            return true
        }

        return CardValidator.isCVCValid(cvc: cvc?.rawValue ?? .empty, cardType: cardType)
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - inputViewStyleManager: instance of manager to customize view
    @objc public override init(inputViewStyleManager: InputViewStyleManager? = nil) {
        super.init(inputViewStyleManager: inputViewStyleManager)
        self.accessibilityIdentifier = "st-security-code-input"
        self.textField.accessibilityIdentifier = "st-security-code-input-textfield"
        self.errorLabel.accessibilityIdentifier = "st-security-code-input-message"
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CvcInputView {

    /// - SeeAlso: SecureFormInputView.customizeView
    override func customizeView() {
        // todo dark mode
        customizeView(inputViewStyleManager: inputViewStyleManager)
    }
    
    /// - SeeAlso: SecureFormInputView.setupProperties
    override func setupProperties() {
        super.setupProperties()

        title = LocalizableKeys.CvcInputView.title.localizedStringOrEmpty
        placeholder = placeholderForTextField(cardType: cardType, expectedLength: expectedInputLength)

        error = LocalizableKeys.CvcInputView.error.localizedStringOrEmpty
        emptyError = LocalizableKeys.CvcInputView.emptyError.localizedStringOrEmpty

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

        if !newText.isEmpty, !newText.isNumeric {
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

// MARK: Helper methods
private extension CvcInputView {
    func placeholderForTextField(cardType: CardType, expectedLength: Int) -> String {
        let pibaPlaceholder = LocalizableKeys.CvcInputView.placeholderPiba.localizedStringOrEmpty
        let cvc3Characters = LocalizableKeys.CvcInputView.placeholder3.localizedStringOrEmpty
        let cvc4Characters = LocalizableKeys.CvcInputView.placeholder4.localizedStringOrEmpty
        return cardType == .piba ? pibaPlaceholder : expectedInputLength == 3 ? cvc3Characters : cvc4Characters
    }
}
