//
//  SecureFormInputView.swift
//  SecureTradingUI
//

import UIKit

public final class SecureFormInputView: WhiteBackgroundBaseView {
    // MARK: Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Fonts.responsive(.bold, ofSizes: [.small: 17, .medium: 18, .large: 20])
        label.numberOfLines = 1
        return label
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
}

extension SecureFormInputView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([stackView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        stackView.addConstraints(equalToSuperview(with: .init(top: 5, left: 5, bottom: -5, right: -5), usingSafeArea: false))
    }
}
