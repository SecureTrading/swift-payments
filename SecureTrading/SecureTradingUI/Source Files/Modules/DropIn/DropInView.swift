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

    @objc public let cardNumberInput: CardNumberInputView = {
        CardNumberInputView()
    }()

    @objc public let expiryDateInput: ExpiryDateInputView = {
        ExpiryDateInputView()
    }()

    @objc public let cvcInput: CvcInputView = {
        CvcInputView()
    }()

    @objc public let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle(Localizable.DropInView.payButton.text, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.backgroundColor = .red
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardNumberInput, expiryDateInput, cvcInput, payButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
}

extension DropInView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    @objc func setupProperties() {
        cardNumberInput.cardNumberInputViewDelegate = self
        cardNumberInput.delegate = self
        cvcInput.delegate = self
        expiryDateInput.delegate = self
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([stackView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        stackView.addConstraints([
            equal(self, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 15),
            equal(self, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, lessOrEqual: -15),
            equal(self, \.leadingAnchor, constant: 30),
            equal(self, \.trailingAnchor, constant: -30)
        ])
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
        payButton.backgroundColor = isFormValid ? UIColor.darkGray : UIColor.red
    }
}

private extension Localizable {
    enum DropInView: String, Localized {
        case payButton
    }
}
