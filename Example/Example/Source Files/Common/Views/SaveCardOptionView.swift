//
//  SaveCardOptionView.swift
//  Example
//

import UIKit

/// A View made of UISwitch and UILabel for selecting whether a card used for transaction should be stored
final class SaveCardOptionView: BaseView {
    // MARK: Properties

    private lazy var toggleButton: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.onTintColor = UIColor.black
        toggle.addTarget(self, action: #selector(SaveCardOptionView.toggleValueChanged(sender:)), for: .valueChanged)
        return toggle
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.SaveCardOptionView.title.text
        label.numberOfLines = 1
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [toggleButton, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()

    // MARK: Public properties

    // Callback triggered by switching the toggle button
    var valueChanged: ((Bool) -> Void)?

    var isSaveCardEnabled: Bool {
        return toggleButton.isOn
    }

    // MARK: - texts

    var title: String = "default" {
        didSet {
            titleLabel.text = title
        }
    }

    // MARK: - colors

    var color: UIColor = .black {
        didSet {
            titleLabel.textColor = color
            toggleButton.onTintColor = color
        }
    }

    // MARK: - fonts

    var titleFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titleLabel.font = titleFont
        }
    }

    // MARK: - functions
    @objc func toggleValueChanged(sender: UISwitch) {
        self.valueChanged?(sender.isOn)
    }
}

extension SaveCardOptionView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    func setupProperties() {
        backgroundColor = .clear
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([stackView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        stackView.addConstraints(equalToSuperview())
    }
}

private extension Localizable {
    enum SaveCardOptionView: String, Localized {
        case title
    }
}
