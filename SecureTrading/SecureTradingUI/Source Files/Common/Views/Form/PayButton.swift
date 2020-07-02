//
//  PayButton.swift
//  SecureTradingUI
//

import UIKit

#if !COCOAPODS
import SecureTradingCore
#endif

/// A subclass of RequestButton, consists of title and spinner for the request interval
@objc public final class PayButton: RequestButton, PayButtonProtocol {
    // MARK: Private properties

    let payButtonStyleManager: PayButtonStyleManager?
    let payButtonDarkModeStyleManager: PayButtonStyleManager?

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
    ///   - payButtonDarkModeStyleManager: instance of dark mode manager to customize view
    @objc public init(payButtonStyleManager: PayButtonStyleManager? = nil, payButtonDarkModeStyleManager: PayButtonStyleManager? = nil) {
        self.payButtonStyleManager = payButtonStyleManager
        self.payButtonDarkModeStyleManager = payButtonDarkModeStyleManager
        super.init(requestButtonStyleManager: payButtonStyleManager, requestButtonDarkModeStyleManager: payButtonDarkModeStyleManager)
        self.configureView()
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions

    public override func configureView() {
        super.configureView()
        guard let title = LocalizableKeys.PayButton.title.localizedString else { return }
        self.title = title
    }
}
