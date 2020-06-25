//
//  PayButton.swift
//  SecureTradingUI
//

import UIKit
import SecureTradingCore

/// A subclass of RequestButton, consists of title and spinner for the request interval
@objc public final class PayButton: RequestButton {
    // MARK: Private properties

    let payButtonStyleManager: PayButtonStyleManager?

    // MARK: Public properties

    // MARK: - texts

    @objc public override var title: String {
        didSet {
            setTitle(title, for: .normal)
        }
    }

    // MARK: Initialization

    /// Initialize an instance and calls required methods
    /// - Parameters:
    ///   - payButtonStyleManager: instance of manager to customize view
    @objc public init(payButtonStyleManager: PayButtonStyleManager? = nil) {
        self.payButtonStyleManager = payButtonStyleManager
        super.init(requestButtonStyleManager: payButtonStyleManager)
        self.configureView()
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions

    public override func configureView() {
        super.configureView()
        
        self.title = TrustPayments.translation(for: TranslationsKeys.PayButton.title)
    }
}

private extension Localizable {
    enum PayButton: String, Localized {
        case title
    }
}
