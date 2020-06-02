//
//  PayButton.swift
//  SecureTradingUI
//

import UIKit

@objc public final class PayButton: UIButton {
    // MARK: Private properties

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    // MARK: Public properties

    @objc public override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = self.enabledBackgroundColor
            } else {
                self.backgroundColor = self.disabledBackgroundColor
            }
        }
    }

    @objc public var enabledBackgroundColor: UIColor = .darkGray

    @objc public var disabledBackgroundColor: UIColor = UIColor.darkGray.withAlphaComponent(0.5)

    @objc public var title: String = "pay" {
        didSet {
            setTitle(title, for: .normal)
        }
    }

    @objc public var titleColor: UIColor = .white {
        didSet {
            tintColor = self.titleColor
        }
    }

    @objc public var titleFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titleLabel?.font = self.titleFont
        }
    }

    // MARK: Initialization

    /// Initialize an instance and calls required methods
    @objc public init() {
        super.init(frame: .zero)
        self.configureView()
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions

    private func configureView() {
        addSubview(self.spinner)
        self.spinner.addConstraints([
            equal(self, \.centerXAnchor),
            equal(self, \.trailingAnchor, constant: -5)
        ])
        layer.cornerRadius = 6
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping

        tintColor = self.titleColor
        titleLabel?.font = self.titleFont

        self.isEnabled = false
        self.title = Localizable.PayButton.title.text
    }

    // MARK: Public functions

    @objc public func startProcessing() {
        self.isUserInteractionEnabled = false
        self.spinner.startAnimating()
    }

    @objc public func stopProcessing() {
        self.isUserInteractionEnabled = true
        self.spinner.stopAnimating()
    }
}

private extension Localizable {
    enum PayButton: String, Localized {
        case title
    }
}
