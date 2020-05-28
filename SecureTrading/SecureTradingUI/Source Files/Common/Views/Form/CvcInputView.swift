//
//  CVCInputView.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 28/05/2020.
//

#if !COCOAPODS
import SecureTradingCard
#endif
import UIKit

@objc public final class CvcInputView: SecureFormInputView {

    // MARK: Private Properties


    // MARK: Public Properties

    @objc public override var inputIsValid: Bool {
        return true // todo
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    @objc public override init() {
        super.init()
    }

    required init?(coder argument: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

}

extension CvcInputView {
    /// - SeeAlso: SecureFormInputView.setupProperties
    override func setupProperties() {
        super.setupProperties()

        title = Localizable.CvcInputView.title.text
        placeholder = Localizable.CvcInputView.placeholder3.text
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

        return true
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
