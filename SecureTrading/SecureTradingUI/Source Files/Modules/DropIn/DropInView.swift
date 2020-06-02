//
//  DropInView.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 02/06/2020.
//

import UIKit

final class DropInView: WhiteBackgroundBaseView {
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

extension DropInView: ViewSetupable {
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
        stackView.addConstraints(equalToSuperview(with: .init(top: 15, left: 30, bottom: -15, right: -30), usingSafeArea: true))
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
