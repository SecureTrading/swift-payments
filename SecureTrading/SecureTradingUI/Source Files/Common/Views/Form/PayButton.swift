//
//  PayButton.swift
//  SecureTradingUI
//

import UIKit

@objc public final class PayButton: UIButton {
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    /// Initialize an instance and calls required methods
    @objc public init() {
        super.init(frame: .zero)
        self.configureView()
    }

    private func configureView() {
        addSubview(self.spinner)
        spinner.addConstraints([
            equal(self, \.centerXAnchor),
            equal(self, \.trailingAnchor, constant: -5)
        ])
        self.layer.cornerRadius = 6
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    @objc public func startProcessing() {
        self.isUserInteractionEnabled = false
        self.spinner.startAnimating()
    }

    @objc public func stopProcessing() {
        self.isUserInteractionEnabled = true
        self.spinner.stopAnimating()
    }
}
