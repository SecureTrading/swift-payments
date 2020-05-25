//
//  SecureFormInputView.swift
//  SecureTradingUI
//

import UIKit

public protocol SecureFormInputViewDelegate: class {
    func inputViewTextFieldDidEndEditing(_ view: SecureFormInputView)
    func inputViewTextFieldDidChange(_ view: SecureFormInputView)
}

public final class SecureFormInputView: WhiteBackgroundBaseView {
    // MARK: Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Fonts.responsive(.regular, ofSizes: [.small: 17, .medium: 18, .large: 20])
        label.numberOfLines = 1
        return label
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = Fonts.responsive(.regular, ofSizes: [.small: 17, .medium: 18, .large: 20])
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: Public properties

    public weak var delegate: SecureFormInputViewDelegate?

    public var regex: String?

    public var isEmpty: Bool {
        guard let text = textField.text else { return true }
        return text.isEmpty
    }

    public var inputIsValid: Bool {
        if regex != nil {
            return validateTextRegEx()
        } else {
            return !isEmpty
        }
    }

    public var isSecuredTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecuredTextEntry
        }
    }

    public var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    // MARK: - texts

    public var title: String = "default" {
        didSet {
            titleLabel.text = title
        }
    }

    public var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    public var placeholder: String = "default" {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: placeholderFont])
        }
    }

    public var error: String = "error" {
        didSet {
            errorLabel.text = error
        }
    }

    // MARK: - colors

    public var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = textColor
        }
    }

    public var textColor: UIColor = .black {
        didSet {
            textField.textColor = textColor
        }
    }

    public var placeholderColor: UIColor = .lightGray {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: placeholderFont])
        }
    }

    public var errorColor: UIColor = .red {
        didSet {
            errorLabel.textColor = errorColor
        }
    }

    // MARK: - fonts

    public var titleFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titleLabel.font = titleFont
        }
    }

    public var textFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            textField.font = textFont
        }
    }

    public var placeholderFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: placeholderFont])
        }
    }

    public var errorFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            errorLabel.font = errorFont
        }
    }

    // MARK: Functions

    private func showHideError(show: Bool) {
        errorLabel.isHidden = !show
    }

    // MARK: - Validation

    private func validateTextRegEx() -> Bool {
        guard let text = text, let regex = regex else { return false }
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }

    @discardableResult
    func validate(silent: Bool, hideError: Bool = false) -> Bool {
        let result = inputIsValid
        if silent == false {
            showHideError(show: !result)
        }

        if result, hideError {
            showHideError(show: false)
        }
        return result
    }
}

extension SecureFormInputView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    func setupProperties() {
        textField.delegate = self
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([stackView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        stackView.addConstraints(equalToSuperview(with: .init(top: 5, left: 5, bottom: -5, right: -5), usingSafeArea: false))
    }
}

// MARK: TextField delegate

extension SecureFormInputView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        validate(silent: false)
        delegate?.inputViewTextFieldDidEndEditing(self)
    }

    @objc func textFieldDidChange(textField: UITextField) {
        validate(silent: true, hideError: true)
        textField.isHidden = isEmpty
        delegate?.inputViewTextFieldDidChange(self)
    }
}
