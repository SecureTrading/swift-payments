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

    let payButtonStyleManager: PayButtonStyleManager?

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
            setTitleColor(self.titleColor, for: .normal)
        }
    }

    @objc public var titleFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titleLabel?.font = self.titleFont
        }
    }

    @objc public var spinnerStyle: UIActivityIndicatorView.Style = .white {
        didSet {
            self.spinner.style = self.spinnerStyle
        }
    }

    @objc public var spinnerColor: UIColor = .white {
        didSet {
            self.spinner.color = self.spinnerColor
        }
    }

    // MARK: Initialization

    /// Initialize an instance and calls required methods
    /// - Parameters:
    ///   - payButtonStyleManager: instance of manager to customize view
    @objc public init(payButtonStyleManager: PayButtonStyleManager? = nil) {
        self.payButtonStyleManager = payButtonStyleManager
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
            equal(self, \.centerYAnchor),
            equal(self, \.trailingAnchor, constant: -15)
        ])
        layer.cornerRadius = 6
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping

        setTitleColor(self.titleColor, for: .normal)
        titleLabel?.font = self.titleFont

        self.title = Localizable.PayButton.title.text

        self.spinner.style = self.spinnerStyle
        self.spinner.color = self.spinnerColor

        self.customizeView(payButtonStyleManager: self.payButtonStyleManager)
        self.isEnabled = false
    }

    private func customizeView(payButtonStyleManager: PayButtonStyleManager?) {
        if let titleColor = payButtonStyleManager?.titleColor {
            self.titleColor = titleColor
        }

        if let enabledBackgroundColor = payButtonStyleManager?.enabledBackgroundColor {
            self.enabledBackgroundColor = enabledBackgroundColor
        }

        if let disabledBackgroundColor = payButtonStyleManager?.disabledBackgroundColor {
            self.disabledBackgroundColor = disabledBackgroundColor
        }

        if let titleFont = payButtonStyleManager?.titleFont {
            self.titleFont = titleFont
        }

        if let spinnerStyle = payButtonStyleManager?.spinnerStyle {
            self.spinnerStyle = spinnerStyle
        }

        if let spinnerColor = payButtonStyleManager?.spinnerColor {
            self.spinnerColor = spinnerColor
        }
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
