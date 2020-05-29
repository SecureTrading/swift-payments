//
//  SingleInputView.swift
//  Example
//

import UIKit

final class SingleInputView: WhiteBackgroundBaseView {
    private let cardNumberInput: CardNumberInputView = {
        CardNumberInputView()
    }()

    private let expiryDateInput: ExpiryDateInputView = {
        ExpiryDateInputView()
    }()

    private let cvcInput: CvcInputView = {
        CvcInputView()
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardNumberInput, expiryDateInput, cvcInput])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
}

extension SingleInputView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    @objc func setupProperties() {
        cardNumberInput.cardNumberInputViewDelegate = self
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([stackView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        stackView.addConstraints([
            equal(self, \.centerYAnchor),
            equal(self, \.centerXAnchor)
        ])
    }
}

extension SingleInputView: CardNumberInputViewDelegate {
    func cardNumberInputViewDidComplete(_ cardNumberInputView: CardNumberInputView) {
        cvcInput.cardType = cardNumberInputView.cardType
        cvcInput.isHidden = !cardNumberInputView.isCVCRequired
    }

    func cardNumberInputViewDidChangeText(_ cardNumberInputView: CardNumberInputView) {
        cvcInput.cardType = cardNumberInputView.cardType
        cvcInput.isHidden = !cardNumberInputView.isCVCRequired
    }
}
