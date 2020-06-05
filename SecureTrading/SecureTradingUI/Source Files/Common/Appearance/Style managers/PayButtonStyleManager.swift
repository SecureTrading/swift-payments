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
    @objc public let borderColor: UIColor?

    // MARK: - fonts

    @objc public let titleFont: UIFont?

    // MARL: - loading spinner

    @objc public let spinnerStyle: UIActivityIndicatorView.Style
    @objc public let spinnerColor: UIColor?

    // MARK: - spacing

    @objc public var buttonContentHeightMargins: HeightMargins?

    @objc public var borderWidth: CGFloat

    @objc public var cornerRadius: CGFloat

    @objc public init(titleColor: UIColor?, enabledBackgroundColor: UIColor?, disabledBackgroundColor: UIColor?, borderColor: UIColor?, titleFont: UIFont?, spinnerStyle: UIActivityIndicatorView.Style = .white, spinnerColor: UIColor? = nil, buttonContentHeightMargins: HeightMargins? = nil, borderWidth: CGFloat = 0, cornerRadius: CGFloat = 5) {
        self.titleColor = titleColor
        self.enabledBackgroundColor = enabledBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.borderColor = borderColor
        self.titleFont = titleFont
        self.spinnerStyle = spinnerStyle
        self.spinnerColor = spinnerColor
        self.buttonContentHeightMargins = buttonContentHeightMargins
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
    }
}
