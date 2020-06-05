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

    var text: String? { get }

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

    // MARK: - spacing

    var titleSpacing: CGFloat { get set }

    var errorSpacing: CGFloat { get set }
}

extension SecureFormInputView {
    public func customizeView(inputViewStyleManager: InputViewStyleManager?) {
        if let titleColor = inputViewStyleManager?.titleColor {
            self.titleColor = titleColor
        }

        if let textFieldBorderColor = inputViewStyleManager?.textFieldBorderColor {
            self.textFieldBorderColor = textFieldBorderColor
        }

        if let textFieldBackgroundColor = inputViewStyleManager?.textFieldBackgroundColor {
            self.textFieldBackgroundColor = textFieldBackgroundColor
        }

        if let textColor = inputViewStyleManager?.textColor {
            self.textColor = textColor
        }

        if let placeholderColor = inputViewStyleManager?.placeholderColor {
            self.placeholderColor = placeholderColor
        }

        if let errorColor = inputViewStyleManager?.errorColor {
            self.errorColor = errorColor
        }

        if let titleFont = inputViewStyleManager?.titleFont {
            self.titleFont = titleFont
        }

        if let textFont = inputViewStyleManager?.textFont {
            self.textFont = textFont
        }

        if let placeholderFont = inputViewStyleManager?.placeholderFont {
            self.placeholderFont = placeholderFont
        }

        if let errorFont = inputViewStyleManager?.errorFont {
            self.errorFont = errorFont
        }

        if let textFieldImage = inputViewStyleManager?.textFieldImage {
            self.textFieldImage = textFieldImage
        }

        if let titleSpacing = inputViewStyleManager?.titleSpacing {
            self.titleSpacing = titleSpacing
        }

        if let errorSpacing = inputViewStyleManager?.errorSpacing {
            self.errorSpacing = errorSpacing
        }
    }
}
