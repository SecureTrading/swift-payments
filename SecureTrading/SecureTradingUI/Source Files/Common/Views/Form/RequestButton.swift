//
//  RequestButton.swift
//  SecureTradingUI
//

import UIKit

/// Button with optional spinner functionality, meant to be subclassed
@objc public class RequestButton: UIButton {
    // MARK: Private properties

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    let requestButtonStyleManager: RequestButtonStyleManager?

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

    // MARK: - texts

    @objc public var title: String = "request" {
        didSet {
            setTitle(title, for: .normal)
        }
    }

    // MARK: - fonts

    @objc public var titleFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            titleLabel?.font = self.titleFont
        }
    }

    // MARK: - colors

    @objc public var enabledBackgroundColor: UIColor = .darkGray

    @objc public var disabledBackgroundColor: UIColor = UIColor.darkGray.withAlphaComponent(0.5)

    @objc public var titleColor: UIColor = .white {
        didSet {
            setTitleColor(self.titleColor, for: .normal)
        }
    }

    @objc public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = self.borderColor.cgColor
        }
    }

    // MARK: - loading spinner

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

    // MARK: - sizes

    @objc public var buttonContentHeightMargins: HeightMargins = HeightMargins(top: 10, bottom: 10) {
        didSet {
            contentEdgeInsets = UIEdgeInsets(top: self.buttonContentHeightMargins.top, left: 0, bottom: self.buttonContentHeightMargins.bottom, right: 0)
        }
    }

    @objc public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @objc public var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    // MARK: Initialization

    /// Initialize an instance and calls required methods
    /// - Parameters:
    ///   - requestButtonStyleManager: instance of manager to customize view
    @objc public init(requestButtonStyleManager: RequestButtonStyleManager? = nil) {
        self.requestButtonStyleManager = requestButtonStyleManager
        super.init(frame: .zero)
        self.configureView()
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions

    public func configureView() {
        addSubview(self.spinner)
        self.spinner.addConstraints([
            equal(self, \.centerYAnchor),
            equal(self, \.trailingAnchor, constant: -15)
        ])

        layer.borderColor = self.borderColor.cgColor
        layer.borderWidth = self.borderWidth
        layer.cornerRadius = self.cornerRadius

        contentEdgeInsets = UIEdgeInsets(top: self.buttonContentHeightMargins.top, left: 0, bottom: self.buttonContentHeightMargins.bottom, right: 0)
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping

        setTitleColor(self.titleColor, for: .normal)
        titleLabel?.font = self.titleFont

        self.spinner.style = self.spinnerStyle
        self.spinner.color = self.spinnerColor

        self.customizeView(requestButtonStyleManager: self.requestButtonStyleManager)
        self.isEnabled = false

        self.highlightIfNeeded()
    }

    private func customizeView(requestButtonStyleManager: RequestButtonStyleManager?) {
        if let titleColor = requestButtonStyleManager?.titleColor {
            self.titleColor = titleColor
        }

        if let enabledBackgroundColor = requestButtonStyleManager?.enabledBackgroundColor {
            self.enabledBackgroundColor = enabledBackgroundColor
        }

        if let disabledBackgroundColor = requestButtonStyleManager?.disabledBackgroundColor {
            self.disabledBackgroundColor = disabledBackgroundColor
        }

        if let borderColor = requestButtonStyleManager?.borderColor {
            self.borderColor = borderColor
        }

        if let titleFont = requestButtonStyleManager?.titleFont {
            self.titleFont = titleFont
        }

        if let spinnerStyle = requestButtonStyleManager?.spinnerStyle {
            self.spinnerStyle = spinnerStyle
        }

        if let spinnerColor = requestButtonStyleManager?.spinnerColor {
            self.spinnerColor = spinnerColor
        }

        if let buttonContentHeightMargins = requestButtonStyleManager?.buttonContentHeightMargins {
            self.buttonContentHeightMargins = buttonContentHeightMargins
        }

        if let borderWidth = requestButtonStyleManager?.borderWidth {
            self.borderWidth = borderWidth
        }

        if let cornerRadius = requestButtonStyleManager?.cornerRadius {
            self.cornerRadius = cornerRadius
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
