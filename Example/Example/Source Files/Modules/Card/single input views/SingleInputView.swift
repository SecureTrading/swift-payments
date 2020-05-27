//
//  SingleInputView.swift
//  Example
//

import UIKit

final class SingleInputView: WhiteBackgroundBaseView {
    private let cardNumberInput: CardNumberInputView = {
        CardNumberInputView()
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardNumberInput])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
}

extension SingleInputView: ViewSetupable {
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
