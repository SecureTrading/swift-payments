//
//  SecureFormInputView.swift
//  SecureTradingUI
//

import UIKit

@objc public class DefaultSecureFormInputView: BaseView, SecureFormInputView {
    // MARK: Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let textFieldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        return textField
    }()

    private lazy var textFieldStackViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = textFieldBackgroundColor
        view.layer.cornerRadius = textFieldCornerRadius
        view.layer.borderWidth = textFieldBorderWidth
        view.layer.borderColor = textFieldBorderColor.cgColor
        return view
    }()

    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldImageView, textField])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: textFieldHeightMargins.top, left: 10, bottom: textFieldHeightMargins.bottom, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textFieldStackView, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    let inputViewStyleManager: InputViewStyleManager?
    let inputViewDarkModeStyleManager: InputViewStyleManager?

    // MARK: Public properties

    @objc public weak var delegate: SecureFormInputViewDelegate?

    @objc public var isEnabled: Bool = true {
        didSet {
            textField.isEnabled = isEnabled
            if isEnabled {
                alpha = 1.0
            } else {
                alpha = 0.4
                textField.text = .empty
                showHideError(show: false)
            }
        }
    }

    @objc public var isEmpty: Bool {
        guard let text = textField.text else { return true }
        return text.isEmpty
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    /// property to be overwritten by inheriting classes
    @objc public private(set) var isInputValid: Bool = false

    @objc public var isSecuredTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecuredTextEntry
        }
    }

    @objc public var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    @objc public var keyboardAppearance: UIKeyboardAppearance = .default {
        didSet {
            textField.keyboardAppearance = keyboardAppearance
        }
    }

    @objc public var textFieldTextAligment: NSTextAlignment = .left {
        didSet {
            textField.textAlignment = textFieldTextAligment
            if textFieldTextAligment == .center {
                textFieldStackView.layoutMargins.right = 20
            }
        }
    }

    // MARK: - texts

    @objc public var title: String = "default" {
        didSet {
            titleLabel.text = title
        }
    }

    @objc public var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    @objc public var placeholder: String = "default" {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: placeholderFont])
        }
    }

    @objc public var error: String = "error" {
        didSet {
            errorLabel.text = error
        }
    }

    @objc public var emptyError: String = "empty error" {
        didSet {
            errorLabel.text = error
        }
    }

    // MARK: - colors

    @objc public var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }

    @objc public var textFieldBorderColor: UIColor = UIColor.lightGray.withAlphaComponent(0.6) {
        didSet {
            textFieldStackViewBackground.layer.borderColor = textFieldBorderColor.cgColor
        }
    }

    @objc public var textFieldBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.2) {
        didSet {
            textFieldStackViewBackground.backgroundColor = textFieldBackgroundColor
        }
    }

    @objc public var textColor: UIColor = .black {
        didSet {
            textField.textColor = textColor
        }
    }

    @objc public var placeholderColor: UIColor = .lightGray {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: placeholderFont])
        }
    }

    @objc public var errorColor: UIColor = .red {
        didSet {
            errorLabel.textColor = errorColor
        }
    }

    @objc public var textFieldImageColor: UIColor = .white {
        didSet {
            textFieldImageView.setImageColor(color: textFieldImageColor)
        }
    }

    // MARK: - fonts

    @objc public var titleFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titleLabel.font = titleFont
        }
    }

    @objc public var textFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            textField.font = textFont
        }
    }

    @objc public var placeholderFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: placeholderFont])
        }
    }

    @objc public var errorFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            errorLabel.font = errorFont
        }
    }

    // MARK: - images

    @objc public var textFieldImage: UIImage? {
        didSet {
            textFieldImageView.image = textFieldImage
        }
    }

    // MARK: - spacing/sizes

    @objc public var titleSpacing: CGFloat = 5 {
        didSet {
            stackView.setCustomSpacing(titleSpacing, after: titleLabel)
        }
    }

    @objc public var errorSpacing: CGFloat = 5 {
        didSet {
            stackView.setCustomSpacing(errorSpacing, after: textFieldStackView)
        }
    }

    @objc public var textFieldBorderWidth: CGFloat = 2 {
        didSet {
            textFieldStackViewBackground.layer.borderWidth = textFieldBorderWidth
        }
    }

    @objc public var textFieldCornerRadius: CGFloat = 5 {
        didSet {
            textFieldStackViewBackground.layer.cornerRadius = textFieldCornerRadius
        }
    }

    @objc public var textFieldHeightMargins: HeightMargins = HeightMargins(top: 5, bottom: 5) {
        didSet {
            textFieldStackView.layoutMargins = UIEdgeInsets(top: textFieldHeightMargins.top, left: 10, bottom: textFieldHeightMargins.bottom, right: 10)
        }
    }

    // MARK: Functions

    public func showHideError(show: Bool) {
        errorLabel.text = isEmpty ? emptyError : error
        errorLabel.isHidden = !show
        textFieldStackViewBackground.layer.borderColor = show ? errorColor.cgColor : textFieldBorderColor.cgColor
        textFieldStackViewBackground.backgroundColor = show ? errorColor.withAlphaComponent(0.1) : textFieldBackgroundColor
        delegate?.showHideError(show)
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - inputViewStyleManager: instance of manager to customize view
    ///   - inputViewDarkModeStyleManager: instance of dark mode manager to customize view
    @objc public init(inputViewStyleManager: InputViewStyleManager? = nil, inputViewDarkModeStyleManager: InputViewStyleManager? = nil) {
        self.inputViewStyleManager = inputViewStyleManager
        self.inputViewDarkModeStyleManager = inputViewDarkModeStyleManager
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Validation

    @discardableResult
    @objc public func validate(silent: Bool) -> Bool {
        validate(silent: silent, hideError: false)
    }

    @discardableResult
    @objc public func validate(silent: Bool, hideError: Bool = false) -> Bool {
        let result = isInputValid
        if silent == false {
            showHideError(show: !result)
        }

        if result, hideError {
            showHideError(show: false)
        }
        return result
    }
}

extension DefaultSecureFormInputView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.customizeView
    @objc func customizeView() {
        var styleManager: InputViewStyleManager!
        if #available(iOS 12.0, *) {
            styleManager = traitCollection.userInterfaceStyle == .dark && inputViewDarkModeStyleManager != nil ? inputViewDarkModeStyleManager : inputViewStyleManager
        } else {
            styleManager = inputViewStyleManager
        }
        customizeView(inputViewStyleManager: styleManager)
    }

    /// - SeeAlso: ViewSetupable.setupProperties
    @objc func setupProperties() {
        backgroundColor = .clear

        textField.delegate = self

        titleLabel.text = title
        titleLabel.textColor = titleColor
        titleLabel.font = titleFont

        textField.text = text
        textField.textColor = textColor
        textField.font = textFont
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: placeholderFont])

        errorLabel.text = error
        errorLabel.textColor = errorColor
        errorLabel.font = errorFont
        stackView.setCustomSpacing(titleSpacing, after: titleLabel)
        stackView.setCustomSpacing(errorSpacing, after: textFieldStackView)

        textFieldImageView.setImageColor(color: textFieldImageColor)

        isEnabled = true
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        textFieldStackViewBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textFieldStackView.insertSubview(textFieldStackViewBackground, at: 0)
        addSubviews([stackView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        textFieldImageView.addConstraints([
            equal(\.widthAnchor, to: 30),
            equal(\.heightAnchor, to: 33)
        ])
        stackView.addConstraints(equalToSuperview(with: .init(top: 0, left: 0, bottom: 0, right: 0), usingSafeArea: false))
    }
}

// MARK: TextField delegate

extension DefaultSecureFormInputView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidEndEditing(_: UITextField) {
        validate(silent: false)
        delegate?.inputViewTextFieldDidEndEditing(self)
    }
}
