//
//  DropInViewStyleManager.swift
//  SecureTradingUI
//

import UIKit

@objc public class DropInViewStyleManager: NSObject {

    @objc public let inputViewStyleManager: InputViewStyleManager?
    @objc public let payButtonStyleManager: PayButtonStyleManager?
    @objc public let backgroundColor: UIColor?

    @objc public init(inputViewStyleManager: InputViewStyleManager?, payButtonStyleManager: PayButtonStyleManager?, backgroundColor: UIColor?) {
        self.inputViewStyleManager = inputViewStyleManager
        self.payButtonStyleManager = payButtonStyleManager
        self.backgroundColor = backgroundColor
    }
}
