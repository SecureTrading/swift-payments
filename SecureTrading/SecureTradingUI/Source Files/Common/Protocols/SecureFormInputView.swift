//
//  SecureFormInputView.swift
//  SecureTradingUI
//

import UIKit

@objc public protocol SecureFormInputViewDelegate: class {
    func inputViewTextFieldDidEndEditing(_ view: SecureFormInputView)
    func showHideError(_ show: Bool)
}

@objc public protocol SecureFormInputView: AnyObject {
    var isEmpty: Bool { get }

    var isInputValid: Bool { get }

    var isSecuredTextEntry: Bool { get set }

    var keyboardType: UIKeyboardType { get set }

    var keyboardAppearance: UIKeyboardAppearance { get set }

    var textFieldTextAligment: NSTextAlignment { get set }

    // MARK: - texts

    var title: String { get set }

    var text: String? { get set }

    var placeholder: String { get set }

    var error: String { get set }

    // MARK: - colors

    var titleColor: UIColor { get set }

    var textFieldBorderColor: UIColor { get set }

    var textFieldBackgroundColor: UIColor { get set }

    var textColor: UIColor { get set }

    var placeholderColor: UIColor { get set }

    var errorColor: UIColor { get set }

    var titleFont: UIFont { get set }

    // MARK: - fonts

    var textFont: UIFont { get set }

    var placeholderFont: UIFont { get set }

    var errorFont: UIFont { get set }

    // MARK: - images

    var textFieldImage: UIImage? { get set }
}
