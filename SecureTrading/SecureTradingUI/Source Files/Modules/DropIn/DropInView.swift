//
//  DropInView.swift
//  SecureTradingUI
//

import UIKit

@objc public final class DropInView: BaseView {
    @objc public var isFormValid: Bool {
        return cardNumberInput.isInputValid && expiryDateInput.isInputValid && cvcInput.isInputValid
    }

    @objc public var payButtonTappedClosure: (() -> Void)? {
        get { return payButton.onTap }
        set { payButton.onTap = newValue }
    }

    @objc public private(set) lazy var cardNumberInput: CardNumberInputView = {
        CardNumberInputView(inputViewStyleManager: dropInViewStyleManager?.inputViewStyleManager)
    }()

    @objc public private(set) lazy var expiryDateInput: ExpiryDateInputView = {
        ExpiryDateInputView(inputViewStyleManager: dropInViewStyleManager?.inputViewStyleManager)
    }()

    @objc public private(set) lazy var cvcInput: CvcInputView = {
        CvcInputView(inputViewStyleManager: dropInViewStyleManager?.inputViewStyleManager)
    }()

    @objc public private(set) lazy var payButton: PayButton = {
        PayButton(payButtonStyleManager: dropInViewStyleManager?.payButtonStyleManager)
    }()

    private lazy var stackView: UIStackView = {
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
        return scrollView
    }()

    let dropInViewStyleManager: DropInViewStyleManager?

    @objc public var spacingBeetwenInputViews: CGFloat = 30 {
        didSet {
            stackView.spacing = spacingBeetwenInputViews
        }
    }

    @objc public var insets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: -15, right: -30)

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - dropInViewStyleManager: instance of manager to customize view
    @objc public init(dropInViewStyleManager: DropInViewStyleManager?) {
        self.dropInViewStyleManager = dropInViewStyleManager
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    private func customizeView(dropInViewStyleManager: DropInViewStyleManager?) {
        backgroundColor = dropInViewStyleManager?.backgroundColor ?? .white
        if let spacingBeetwenInputViews = dropInViewStyleManager?.spacingBeetwenInputViews {
            self.spacingBeetwenInputViews = spacingBeetwenInputViews
        }
        if let insets = dropInViewStyleManager?.insets {
            self.insets = insets
        }
        buildScrollViewConstraints()
    }

    private func buildScrollViewConstraints() {
        scrollView.addConstraints([
            equal(self, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            equal(self, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom),
            equal(self, \.leadingAnchor, constant: insets.left),
            equal(self, \.trailingAnchor, constant: insets.right)
        ])
    }
}

extension DropInView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    @objc func setupProperties() {
        cardNumberInput.cardNumberInputViewDelegate = self
        cardNumberInput.delegate = self
        cvcInput.delegate = self
        expiryDateInput.delegate = self
        cardNumberInput.becomeFirstResponder()

        customizeView(dropInViewStyleManager: dropInViewStyleManager)
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        scrollView.addSubview(stackView)
        addSubviews([scrollView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {

        scrollView.addConstraints([
            equal(stackView, \.widthAnchor, to: \.widthAnchor, constant: 0.0)
        ])

        stackView.addConstraints(equalToSuperview(with: .init(top: 0, left: 0, bottom: 0, right: 0), usingSafeArea: false))
    }
}

extension DropInView: CardNumberInputViewDelegate {
    public func cardNumberInputViewDidComplete(_ cardNumberInputView: CardNumberInputView) {
        cvcInput.cardType = cardNumberInputView.cardType
        cvcInput.isHidden = !cardNumberInputView.isCVCRequired
    }

    public func cardNumberInputViewDidChangeText(_ cardNumberInputView: CardNumberInputView) {
        cvcInput.cardType = cardNumberInputView.cardType
        cvcInput.isHidden = !cardNumberInputView.isCVCRequired
    }
}

extension DropInView: SecureFormInputViewDelegate {
    public func inputViewTextFieldDidEndEditing(_ view: SecureFormInputView) {}

    public func showHideError(_ show: Bool) {
        payButton.isEnabled = isFormValid
    }
}
