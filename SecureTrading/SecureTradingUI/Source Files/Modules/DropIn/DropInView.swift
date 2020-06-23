//
//  DropInView.swift
//  SecureTradingUI
//

import UIKit

@objc open class DropInView: BaseView, DropInViewProtocol {
    @objc public var isFormValid: Bool {
        return cardNumberInput.isInputValid && expiryDateInput.isInputValid && cvcInput.isInputValid
    }

    @objc public var payButtonTappedClosure: (() -> Void)? {
        get { return payButton.onTap }
        set { payButton.onTap = newValue }
    }

    @objc public private(set) lazy var cardNumberInput: CardNumberInput = {
        CardNumberInputView(inputViewStyleManager: dropInViewStyleManager?.inputViewStyleManager)
    }()

    @objc public private(set) lazy var expiryDateInput: ExpiryDateInput = {
        ExpiryDateInputView(inputViewStyleManager: dropInViewStyleManager?.inputViewStyleManager)
    }()

    @objc public private(set) lazy var cvcInput: CvcInput = {
        CvcInputView(inputViewStyleManager: dropInViewStyleManager?.inputViewStyleManager)
    }()

    @objc public private(set) lazy var payButton: PayButtonProtocol = {
        let styleManager = dropInViewStyleManager?.requestButtonStyleManager as? PayButtonStyleManager
        return PayButton(payButtonStyleManager: styleManager)
    }()

    private let stackContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    public lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardNumberInput, expiryDateInput, cvcInput, payButton])
        stackView.axis = .vertical
        stackView.spacing = spacingBeetwenInputViews
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let stackViewLeadingConstraint = "stackViewLeadingConstraint"
    private let stackViewTrailingConstraint = "stackViewTrailingConstraint"
    private let stackViewTopConstraint = "stackViewTopConstraint"
    private let stackViewBottomConstraint = "stackViewBottomConstraint"

    let dropInViewStyleManager: DropInViewStyleManager?

    @objc public var spacingBeetwenInputViews: CGFloat = 30 {
        didSet {
            stackView.spacing = spacingBeetwenInputViews
        }
    }

    @objc public var insets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: -15, right: -30) {
        didSet {
            buildStackViewConstraints()
        }
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - dropInViewStyleManager: instance of manager to customize view
    @objc public init(dropInViewStyleManager: DropInViewStyleManager?) {
        self.dropInViewStyleManager = dropInViewStyleManager
        super.init()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    /// Set scroll view bottom inset to the keyboard height
    /// - Parameter height: bottom inset
    public func moveUpTableView(height: CGFloat) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0,
                                         bottom: height, right: 0.0)
        adjustContentInsets(contentInsets)
    }

    /// Set scroll view bottom inset to the default value
    public func moveDownTableView() {
        adjustContentInsets(.zero)
    }

    /// Change scroll view insets
    private func adjustContentInsets(_ contentInsets: UIEdgeInsets) {
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    private func customizeView(dropInViewStyleManager: DropInViewStyleManager?) {
        backgroundColor = dropInViewStyleManager?.backgroundColor ?? .white
        if let spacingBeetwenInputViews = dropInViewStyleManager?.spacingBeetwenInputViews {
            self.spacingBeetwenInputViews = spacingBeetwenInputViews
        }
        if let insets = dropInViewStyleManager?.insets {
            self.insets = insets
        }
        buildStackViewConstraints()
    }

    private func buildStackViewConstraints() {
        if let top = stackContainer.constraint(withIdentifier: stackViewTopConstraint) {
            top.isActive = false
        }

        if let bottom = stackContainer.constraint(withIdentifier: stackViewBottomConstraint) {
            bottom.isActive = false
        }

        if let leading = stackContainer.constraint(withIdentifier: stackViewLeadingConstraint) {
            leading.isActive = false
        }

        if let trailing = stackContainer.constraint(withIdentifier: stackViewTrailingConstraint) {
            trailing.isActive = false
        }

        stackView.addConstraints([
            equal(stackContainer, \.topAnchor, \.topAnchor, constant: insets.top, identifier: stackViewTopConstraint),
            equal(stackContainer, \.bottomAnchor, \.bottomAnchor, constant: insets.bottom, identifier: stackViewBottomConstraint),
            equal(stackContainer, \.leadingAnchor, \.leadingAnchor, constant: insets.left, identifier: stackViewLeadingConstraint),
            equal(stackContainer, \.trailingAnchor, \.trailingAnchor, constant: insets.right, identifier: stackViewTrailingConstraint)
        ])
    }
}

extension DropInView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    @objc func setupProperties() {
        (cardNumberInput as? CardNumberInputView)?.cardNumberInputViewDelegate = self
        (cardNumberInput as? CardNumberInputView)?.delegate = self
        (cvcInput as? CvcInputView)?.delegate = self
        (expiryDateInput as? ExpiryDateInputView)?.delegate = self
        cardNumberInput.becomeFirstResponder()

        customizeView(dropInViewStyleManager: dropInViewStyleManager)
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    @objc open func setupViewHierarchy() {
        stackContainer.addSubview(stackView)
        scrollView.addSubview(stackContainer)
        addSubviews([scrollView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        scrollView.addConstraints([
            equal(self, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 0),
            equal(self, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            equal(self, \.leadingAnchor, constant: 0),
            equal(self, \.trailingAnchor, constant: 0)
        ])

        stackContainer.addConstraints(equalToSuperview(with: .init(top: 0, left: 0, bottom: 0, right: 0), usingSafeArea: false))

        stackContainer.addConstraints([
            equal(self, \.widthAnchor, to: \.widthAnchor, constant: 0.0)
        ])

        buildStackViewConstraints()
    }
}

extension DropInView: CardNumberInputViewDelegate {
    public func cardNumberInputViewDidComplete(_ cardNumberInputView: CardNumberInputView) {
        (cvcInput as? CvcInputView)?.cardType = cardNumberInputView.cardType
        cvcInput.isEnabled = cardNumberInputView.isCVCRequired
    }

    public func cardNumberInputViewDidChangeText(_ cardNumberInputView: CardNumberInputView) {
        (cvcInput as? CvcInputView)?.cardType = cardNumberInputView.cardType
        cvcInput.isEnabled = cardNumberInputView.isCVCRequired
    }
}

extension DropInView: SecureFormInputViewDelegate {
    public func inputViewTextFieldDidEndEditing(_ view: SecureFormInputView) {}

    public func showHideError(_ show: Bool) {
        payButton.isEnabled = isFormValid
    }
}
