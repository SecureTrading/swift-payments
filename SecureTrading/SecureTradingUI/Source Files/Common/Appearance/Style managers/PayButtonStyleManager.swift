//
//  PayButtonStyleManager.swift
//  SecureTradingUI
//

import UIKit

@objc public class PayButtonStyleManager: NSObject {

    // MARK: - colors

    @objc public let titleColor: UIColor?
    @objc public let enabledBackgroundColor: UIColor?
    @objc public let disabledBackgroundColor: UIColor?

    // MARK: - fonts

    @objc public let titleFont: UIFont?

    // MARL: - loading spinner

    @objc public let spinnerStyle: UIActivityIndicatorView.Style
    @objc public let spinnerColor: UIColor?

    @objc public init(titleColor: UIColor?, enabledBackgroundColor: UIColor?, disabledBackgroundColor: UIColor?, titleFont: UIFont?, spinnerStyle: UIActivityIndicatorView.Style = .white, spinnerColor: UIColor?) {
        self.titleColor = titleColor
        self.enabledBackgroundColor = enabledBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.titleFont = titleFont
        self.spinnerStyle = spinnerStyle
        self.spinnerColor = spinnerColor
    }
}
