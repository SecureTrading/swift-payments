//
//  ExpiryDateInputView.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCard
#endif
import UIKit

class MonthTextField: BackwardTextField {
    /// Returns automatically the completed text for the current month. For example, if you enter "4", it should return "04" instead.
    /// - Parameter text: entered text
    /// - Returns: auto-completed string.
    func autocomplete(_ text: String) -> String {
        let length = text.count
        if length != 1 {
            return text
        }

        let monthNumber = Int(text) ?? 0
        if monthNumber > 1 {
            return "0" + text
        }

        return text
    }
}

class YearTextField: BackwardTextField {}

@objc public class ExpiryDateInputView: BaseView, SecureFormInputView {
    // MARK: Properties

    let titleLabel: UILabel = {
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

    let monthTextField: MonthTextField = {
        let textField = MonthTextField()
        textField.autocorrectionType = .no
        textField.textAlignment = .right
        return textField
    }()

    let yearTextField: YearTextField = {
        let textField = YearTextField()
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        return textField
    }()

    private let separatorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private lazy var textFieldStackViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = textFieldBackgroundColor
        view.layer.cornerRadius = textFieldCornerRadius
        view.layer.borderWidth = textFieldBorderWidth
        view.layer.borderColor = textFieldBorderColor.cgColor
        return view
    }()

    private let textFieldInternalStackViewContainer: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var textFieldInternalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [monthTextField, separatorLabel, yearTextField])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldImageView, textFieldInternalStackViewContainer])
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
        label.numberOfLines = 1
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

    private var placeholderPrivate: String = "MM/YY"

    private let tFieldStViewLeadingEqualConstraint = "tFieldStViewLeadingEqualConstraint"
    private let tFieldStViewTrailingEqualConstraint = "tFieldStViewTrailingEqualConstraint"
    private let tFieldStViewLeadingGreaterConstraint = "tFieldStViewLeadingGreaterConstraint"
    private let tFieldStViewTrailingLessConstraint = "tFieldStViewTrailingLessConstraint"
    private let tFieldStViewCenterXConstraint = "tFieldStViewCenterXConstraint"

    private var hasStartedMonthEditing = false
    private var hasStartedYearEditing = false

    private var expectedInputLength: Int {
        return 2
    }

    private let setWithoutSpecialChars = CharacterSet(charactersIn:
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    )

    let inputViewStyleManager: InputViewStyleManager?

    // MARK: Public properties

    @objc public var expiryDate: ExpiryDate {
        return ExpiryDate(rawValue: text ?? .empty)
    }

    @objc public weak var delegate: SecureFormInputViewDelegate?

    @objc public var isEmpty: Bool {
        return monthTextField.text?.isEmpty ?? true && yearTextField.text?.isEmpty ?? true
    }

    @objc public var isInputValid: Bool {
        return CardValidator.isExpirationDateValid(date: expiryDate.rawValue, separator: separatorLabel.text ?? "/")
    }

    @objc public var isSecuredTextEntry: Bool = false {
        didSet {
            monthTextField.isSecureTextEntry = isSecuredTextEntry
            yearTextField.isSecureTextEntry = isSecuredTextEntry
        }
    }

    @objc public var keyboardType: UIKeyboardType = .default {
        didSet {
            monthTextField.keyboardType = keyboardType
            yearTextField.keyboardType = keyboardType
        }
    }

    @objc public var keyboardAppearance: UIKeyboardAppearance = .default {
        didSet {
            monthTextField.keyboardAppearance = keyboardAppearance
            yearTextField.keyboardAppearance = keyboardAppearance
        }
    }

    @objc public var textFieldTextAligment: NSTextAlignment = .left {
        didSet {
            rebuildTextFieldInternalStackViewConstraints()

            let leadingEqualConstraint = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewLeadingEqualConstraint)
            let trailingEqualConstraint = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewTrailingEqualConstraint)
            let leadingGreaterConstraint = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewLeadingGreaterConstraint)
            let trailingLessConstraint = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewTrailingLessConstraint)
            let centerXConstraint = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewCenterXConstraint)

            switch textFieldTextAligment {
            case .center, .natural:
                leadingEqualConstraint?.isActive = false
                leadingGreaterConstraint?.isActive = true
                trailingEqualConstraint?.isActive = false
                trailingLessConstraint?.isActive = true
                centerXConstraint?.isActive = true
            case .left, .justified:
                leadingEqualConstraint?.isActive = true
                leadingGreaterConstraint?.isActive = false
                trailingEqualConstraint?.isActive = false
                trailingLessConstraint?.isActive = true
                centerXConstraint?.isActive = false
            case .right:
                leadingEqualConstraint?.isActive = false
                leadingGreaterConstraint?.isActive = true
                trailingEqualConstraint?.isActive = true
                trailingLessConstraint?.isActive = false
                centerXConstraint?.isActive = false
            @unknown default:
                return
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
        return "\(monthTextField.text ?? .empty)\(separatorLabel.text ?? .empty)\(yearTextField.text ?? .empty)"
    }

    @objc public var placeholder: String {
        get {
            return placeholderPrivate
        }
        set {
            updatePlaceholder(current: newValue)
            placeholderPrivate = newValue
        }
    }

    @objc public var error: String = "error" {
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
            monthTextField.textColor = textColor
            yearTextField.textColor = textColor
        }
    }

    @objc public var placeholderColor: UIColor = .lightGray {
        didSet {
            updatePlaceholder(current: placeholderPrivate)
        }
    }

    @objc public var errorColor: UIColor = .red {
        didSet {
            errorLabel.textColor = errorColor
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
            monthTextField.font = textFont
            yearTextField.font = textFont
        }
    }

    @objc public var placeholderFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            updatePlaceholder(current: placeholderPrivate)
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

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - inputViewStyleManager: instance of manager to customize view
    @objc public init(inputViewStyleManager: InputViewStyleManager? = nil) {
        self.inputViewStyleManager = inputViewStyleManager
        super.init()
        self.accessibilityIdentifier = "st-expiration-date-input"
        self.monthTextField.accessibilityIdentifier = "st-expiration-date-input-month-textfield"
        self.yearTextField.accessibilityIdentifier = "st-expiration-date-input-year-textfield"
        self.errorLabel.accessibilityIdentifier = "st-expiration-date-message"
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    private func updatePlaceholder(current: String) {
        guard let range = current.rangeOfCharacter(from: setWithoutSpecialChars.inverted) else { return }
        let separator = current[range.lowerBound..<range.upperBound]
        guard separator.count == 1 else { return }

        separatorLabel.text = String(separator)
        let placeholderArray = current.components(separatedBy: separator)

        separatorLabel.textColor = placeholderColor
        monthTextField.attributedPlaceholder = NSAttributedString(string: placeholderArray[0],
                                                                  attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: placeholderFont])
        yearTextField.attributedPlaceholder = NSAttributedString(string: placeholderArray[1],
                                                                 attributes: [NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: placeholderFont])
    }

    private func rebuildTextFieldInternalStackViewConstraints() {
        if let leadingEqual = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewLeadingEqualConstraint) {
            leadingEqual.isActive = false
        }

        if let trailingEqual = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewTrailingEqualConstraint) {
            trailingEqual.isActive = false
        }

        if let leadingGreater = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewLeadingGreaterConstraint) {
            leadingGreater.isActive = false
        }

        if let trailingLess = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewTrailingLessConstraint) {
            trailingLess.isActive = false
        }

        if let centerX = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewCenterXConstraint) {
            centerX.isActive = false
        }

        textFieldInternalStackView.addConstraints([
            equal(textFieldInternalStackViewContainer, \.leadingAnchor, \.leadingAnchor, greaterOrEqual: 0, identifier: tFieldStViewLeadingGreaterConstraint),
            equal(textFieldInternalStackViewContainer, \.trailingAnchor, \.trailingAnchor, lessOrEqual: 0, identifier: tFieldStViewTrailingLessConstraint),
            equal(textFieldInternalStackViewContainer, \.leadingAnchor, \.leadingAnchor, constant: 0, identifier: tFieldStViewLeadingEqualConstraint),
            equal(textFieldInternalStackViewContainer, \.trailingAnchor, \.trailingAnchor, constant: 0, identifier: tFieldStViewTrailingEqualConstraint),
            equal(textFieldInternalStackViewContainer, \.centerXAnchor, \.centerXAnchor, constant: 0, identifier: tFieldStViewCenterXConstraint)
        ])
    }

    func showHideError(show: Bool) {
        errorLabel.isHidden = !show
        textFieldStackViewBackground.layer.borderColor = show ? errorColor.cgColor : textFieldBorderColor.cgColor
        textFieldStackViewBackground.backgroundColor = show ? errorColor.withAlphaComponent(0.2) : textFieldBackgroundColor
        delegate?.showHideError(show)
    }

    // MARK: - Validation

    @discardableResult
    func validate(silent: Bool, hideError: Bool = false) -> Bool {
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

extension ExpiryDateInputView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    @objc func setupProperties() {
        backgroundColor = .clear

        yearTextField.deleteLastCharCallback = { [weak self] _ in
            self?.monthTextField.becomeFirstResponder()
        }

        monthTextField.delegate = self
        yearTextField.delegate = self

        titleLabel.textColor = titleColor
        titleLabel.font = titleFont

        monthTextField.text = text
        monthTextField.textColor = textColor
        monthTextField.font = textFont
        yearTextField.text = text
        yearTextField.textColor = textColor
        yearTextField.font = textFont

        errorLabel.textColor = errorColor
        errorLabel.font = errorFont

        title = Localizable.ExpiryDateInputView.title.text
        placeholder = Localizable.ExpiryDateInputView.placeholder.text
        error = Localizable.ExpiryDateInputView.error.text

        keyboardType = .numberPad

        textFieldTextAligment = .center

        textFieldImage = UIImage(named: "calendar", in: Bundle(for: CvcInputView.self), compatibleWith: nil)

        stackView.setCustomSpacing(titleSpacing, after: titleLabel)
        stackView.setCustomSpacing(errorSpacing, after: textFieldStackView)

        customizeView(inputViewStyleManager: inputViewStyleManager)
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        textFieldStackViewBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textFieldStackView.insertSubview(textFieldStackViewBackground, at: 0)
        textFieldInternalStackViewContainer.addSubview(textFieldInternalStackView)
        addSubviews([stackView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        textFieldImageView.addConstraints([
            equal(\.widthAnchor, to: 30),
            equal(\.heightAnchor, to: 33)
        ])

        textFieldInternalStackView.addConstraints([
            equal(textFieldInternalStackViewContainer, \.topAnchor),
            equal(textFieldInternalStackViewContainer, \.bottomAnchor)
        ])

        rebuildTextFieldInternalStackViewConstraints()

        if let leadingEqual = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewLeadingEqualConstraint) {
            leadingEqual.isActive = false
        }

        if let trailingEqual = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewTrailingEqualConstraint) {
            trailingEqual.isActive = false
        }

        if let leadingGreater = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewLeadingGreaterConstraint) {
            leadingGreater.isActive = true
        }

        if let trailingLess = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewTrailingLessConstraint) {
            trailingLess.isActive = true
        }

        if let centerX = textFieldInternalStackViewContainer.constraint(withIdentifier: tFieldStViewCenterXConstraint) {
            centerX.isActive = true
        }

        stackView.addConstraints(equalToSuperview(with: .init(top: 0, left: 0, bottom: 0, right: 0), usingSafeArea: false))
    }
}

// MARK: TextField delegate

extension ExpiryDateInputView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        hasStartedMonthEditing = textField is MonthTextField ? true : hasStartedMonthEditing
        hasStartedYearEditing = textField is YearTextField ? true : hasStartedYearEditing
        if (textField.text ?? .empty).isEmpty || textField is MonthTextField {
            textField.text = UITextField.emptyCharacter
        }
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if hasStartedMonthEditing, hasStartedYearEditing {
            validate(silent: false)
        }
        delegate?.inputViewTextFieldDidEndEditing(self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = NSString(string: textField.text ?? .empty).replacingCharacters(in: range, with: string).replacingOccurrences(of: UITextField.emptyCharacter, with: String.empty)

        let deletingLastChar = !(textField.text ?? .empty).isEmpty && textField.text != UITextField.emptyCharacter && newText.isEmpty
        if deletingLastChar {
            textField.text = UITextField.emptyCharacter
            return false
        }

        if !newText.isEmpty, !newText.isNumeric {
            return false
        }

        newText = (textField as? MonthTextField)?.autocomplete(newText) ?? newText

        let hasOverflow = newText.count > expectedInputLength
        let index = hasOverflow ?
            newText.index(newText.startIndex, offsetBy: expectedInputLength) :
            newText.index(newText.startIndex, offsetBy: newText.count)
        let currentTextFieldText = String(newText[..<index])
        let overflowText = String(newText[index...])

        if newText.count <= 2 {
            textField.text = currentTextFieldText
        }

        if textField is MonthTextField, currentTextFieldText.count > 1 {
            self.textField(textField, didEnterFullData: currentTextFieldText)
        }

        if isInputValid {
            showHideError(show: false)
        }

        if !overflowText.isEmpty {
            self.textField(textField, didEnterOverflowData: overflowText)
        }

        return false
    }
}

extension ExpiryDateInputView {
    /// Called whenever full data has been entered into `textField`.
    /// - Parameters:
    ///   - textField: text field with updated information
    ///   - didEnterFullData: Full information that has been entered into the `textField`
    public func textField(_ textField: UITextField, didEnterFullData: String) {
        selectNext(textField, prefillText: nil)
    }

    /// Called every time more text is entered into `textField` than necessary.
    /// - Parameters:
    ///   - textField: A text field that has received more information than required.
    ///   - overflowText: Text overflow that does not fit into the `textField` and can be entered into the next receiver
    public func textField(_ textField: UITextField, didEnterOverflowData overflowText: String) {
        selectNext(textField, prefillText: overflowText)
    }

    /// Moves on to the next text field
    /// - Parameters:
    ///   - textField: current text field
    ///   - prefillText: text that will be entered in the next text field
    private func selectNext(_ textField: UITextField, prefillText: String?) {
        var nextTextField: UITextField?
        if textField == monthTextField {
            nextTextField = yearTextField
        }

        nextTextField?.becomeFirstResponder()

        guard let prefillText = prefillText, let nextField = nextTextField else {
            return
        }

        nextTextField?.delegate?.textField?(nextField, shouldChangeCharactersIn: NSRange(location: 0, length: (nextField.text ?? .empty).count), replacementString: prefillText)
    }
}

private extension Localizable {
    enum ExpiryDateInputView: String, Localized {
        case title
        case placeholder
        case error
    }
}
