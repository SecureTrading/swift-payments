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
    /// - SeeAlso: SecureFormInputView.setupProperties
    override func setupProperties() {
        super.setupProperties()

        title = Localizable.CvcInputView.title.text
        placeholder = cardType == .piba ? Localizable.CvcInputView.placeholderPiba.text : expectedInputLength == 3 ? Localizable.CvcInputView.placeholder3.text : Localizable.CvcInputView.placeholder4.text
        error = Localizable.CvcInputView.error.text
        emptyError = Localizable.CvcInputView.emptyError.text

        keyboardType = .numberPad

        isSecuredTextEntry = true

        textFieldTextAligment = .center

        textFieldImage = UIImage(named: "cvc", in: Bundle(for: CvcInputView.self), compatibleWith: nil)

        customizeView(inputViewStyleManager: inputViewStyleManager)
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

private extension Localizable {
    enum CvcInputView: String, Localized {
        case title
        case placeholder3
        case placeholder4
        case placeholderPiba
        case error
        case emptyError
    }
}
