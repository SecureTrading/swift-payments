//
//  DropInView.swift
//  SecureTradingUI
//

import UIKit

final class DropInView: WhiteBackgroundBaseView {
    var payButtonTappedClosure: (() -> Void)? {
        get { return payButton.onTap }
        set { payButton.onTap = newValue }
    }

    private let cardNumberInput: CardNumberInputView = {
        CardNumberInputView()
    }()

    private let expiryDateInput: ExpiryDateInputView = {
        ExpiryDateInputView()
    }()

    private let cvcInput: CvcInputView = {
        CvcInputView()
    }()

    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle(Localizable.DropInView.payButton.text, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.backgroundColor = .darkGray
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
    func cardNumberInputViewDidComplete(_ cardNumberInputView: CardNumberInputView) {
        cvcInput.cardType = cardNumberInputView.cardType
        cvcInput.isHidden = !cardNumberInputView.isCVCRequired
    }

    func cardNumberInputViewDidChangeText(_ cardNumberInputView: CardNumberInputView) {
        cvcInput.cardType = cardNumberInputView.cardType
        cvcInput.isHidden = !cardNumberInputView.isCVCRequired
    }
}

extension DropInView: SecureFormInputViewDelegate {
    func inputViewTextFieldDidEndEditing(_ view: SecureFormInputView) {}

    func showHideError(_ show: Bool) {
        let isFormValid = cardNumberInput.isInputValid && expiryDateInput.isInputValid && cvcInput.isInputValid
        payButton.backgroundColor = isFormValid ? UIColor.darkGray : UIColor.red
    }
}

private extension Localizable {
    enum DropInView: String, Localized {
        case payButton
    }
}
