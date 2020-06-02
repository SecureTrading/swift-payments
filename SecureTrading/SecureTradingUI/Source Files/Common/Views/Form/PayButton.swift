//
//  PayButton.swift
//  SecureTradingUI
//

import UIKit

@objc public final class PayButton: UIButton {
    // MARK: Properties

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

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
        self.layer.cornerRadius = 6
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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

    @objc public var title: String = "default" {
        didSet {

        }
    }

    @objc public var titleColor: UIColor = .black {
        didSet {

        }
    }

    @objc public var enabledBackgroundColor: UIColor = .black {
        didSet {

        }
    }

    @objc public var disabledBackgroundColor: UIColor = .black {
        didSet {

        }
    }

    @objc public var titleFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {

        }
    }
}
