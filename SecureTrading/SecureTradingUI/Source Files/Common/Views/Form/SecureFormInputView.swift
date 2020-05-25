//
//  SecureFormInputView.swift
//  SecureTradingUI
//

import UIKit

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

    // MARK: Texts

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
}

extension SecureFormInputView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([stackView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        stackView.addConstraints(equalToSuperview(with: .init(top: 5, left: 5, bottom: -5, right: -5), usingSafeArea: false))
    }
}
