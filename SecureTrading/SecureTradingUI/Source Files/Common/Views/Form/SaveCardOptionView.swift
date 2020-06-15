//
//  SaveCardOptionView.swift
//  SecureTradingUI
//

import UIKit

@objc public final class SaveCardOptionView: BaseView {
    // MARK: Properties

    private let toggleButton: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = UIColor.black
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

    let inputViewStyleManager: InputViewStyleManager?

    // MARK: Public properties

    @objc public var isSaveCardEnabled: Bool {
        return toggleButton.isOn
    }

    // MARK: - texts

    @objc public var title: String = "default" {
        didSet {
            titleLabel.text = title
        }
    }

    // MARK: - colors

    @objc public var color: UIColor = .black {
        didSet {
            titleLabel.textColor = color
            toggleButton.onTintColor = color
        }
    }

    // MARK: - fonts

    @objc public var titleFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titleLabel.font = titleFont
        }
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - inputViewStyleManager: instance of manager to customize view
    @objc public init(inputViewStyleManager: InputViewStyleManager? = nil) {
        self.inputViewStyleManager = inputViewStyleManager
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SaveCardOptionView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    @objc func setupProperties() {
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
