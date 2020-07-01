//
//  DropInViewStyleManager.swift
//  SecureTradingUI
//

import UIKit

@objc public class DropInViewStyleManager: NSObject {

    @objc public let inputViewStyleManager: InputViewStyleManager?
    @objc public let requestButtonStyleManager: RequestButtonStyleManager?
    @objc public let backgroundColor: UIColor?
    @objc public let spacingBeetwenInputViews: CGFloat
    @objc public let insets: UIEdgeInsets

    @objc public init(inputViewStyleManager: InputViewStyleManager?,
                      requestButtonStyleManager: RequestButtonStyleManager?,
                      backgroundColor: UIColor?,
                      spacingBeetwenInputViews: CGFloat = 30,
                      insets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: -15, right: -30)) {
        self.inputViewStyleManager = inputViewStyleManager
        self.requestButtonStyleManager = requestButtonStyleManager
        self.backgroundColor = backgroundColor
        self.spacingBeetwenInputViews = spacingBeetwenInputViews
        self.insets = insets
    }
}
