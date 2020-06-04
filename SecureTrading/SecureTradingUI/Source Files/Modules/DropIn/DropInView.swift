//
//  DropInView.swift
//  SecureTradingUI
//

import UIKit

@objc public final class DropInView: WhiteBackgroundBaseView {
    @objc public var isFormValid: Bool {
        return cardNumberInput.isInputValid && expiryDateInput.isInputValid && cvcInput.isInputValid
    }

    @objc public var payButtonTappedClosure: (() -> Void)? {
        get { return payButton.onTap }
        set { payButton.onTap = newValue }
    }

    @objc public lazy private(set) var cardNumberInput: CardNumberInputView = {
        CardNumberInputView(inputViewStyleManager: dropInViewStyleManager?.inputViewStyleManager)
    }()

    @objc public lazy private(set) var expiryDateInput: ExpiryDateInputView = {
        ExpiryDateInputView(inputViewStyleManager: dropInViewStyleManager?.inputViewStyleManager)
    }()

    @objc public lazy private(set) var cvcInput: CvcInputView = {
        CvcInputView(inputViewStyleManager: dropInViewStyleManager?.inputViewStyleManager)
    }()

    @objc public lazy private(set) var payButton: PayButton = {
        PayButton(payButtonStyleManager: dropInViewStyleManager?.payButtonStyleManager)
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardNumberInput, expiryDateInput, cvcInput, payButton])
        stackView.axis = .vertical
        stackView.spacing = 30
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
}

extension DropInView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    @objc func setupProperties() {
        cardNumberInput.cardNumberInputViewDelegate = self
        cardNumberInput.delegate = self
        cvcInput.delegate = self
        expiryDateInput.delegate = self
        cardNumberInput.becomeFirstResponder()
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        scrollView.addSubview(stackView)
        addSubviews([scrollView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        scrollView.addConstraints([
            equal(self, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 15),
            equal(self, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            equal(self, \.leadingAnchor, constant: 30),
            equal(self, \.trailingAnchor, constant: -30)
        ])

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
