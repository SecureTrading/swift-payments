//
//  ExpiryDateInputView.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 28/05/2020.
//

#if !COCOAPODS
import SecureTradingCard
#endif
import UIKit

@objc public final class ExpiryDateInputView: SecureFormInputView {
    // MARK: Private Properties


    // MARK: Public Properties

    @objc public override var inputIsValid: Bool {
        return true
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

extension ExpiryDateInputView {
    /// - SeeAlso: SecureFormInputView.setupProperties
    override func setupProperties() {
        super.setupProperties()

        title = Localizable.ExpiryDateInputView.title.text
        placeholder = Localizable.ExpiryDateInputView.placeholder.text
        error = Localizable.ExpiryDateInputView.error.text

        keyboardType = .numberPad

        textFieldTextAligment = .center

        textFieldImage = UIImage(named: "cvc", in: Bundle(for: CvcInputView.self), compatibleWith: nil)
    }
}

// MARK: TextField delegate

extension ExpiryDateInputView {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return false
    }
}

private extension Localizable {
    enum ExpiryDateInputView: String, Localized {
        case title
        case placeholder
        case error
    }
}
