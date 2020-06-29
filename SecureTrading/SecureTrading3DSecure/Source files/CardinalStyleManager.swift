//
//  CardinalStyleManager.swift
//  SecureTrading3DSecure
//

import UIKit

@objc public class CardinalToolbarStyleManager: NSObject {}

@objc public class CardinalLabelStyleManager: NSObject {
    // MARK: - colors

    @objc public let textColor: UIColor?
    @objc public let headingTextColor: UIColor?

    // MARK: - fonts

    @objc public let textFont: UIFont?
    @objc public let headingTextFont: UIFont?

    @objc public init(textColor: UIColor?, textFont: UIFont?, headingTextColor: UIColor?, headingTextFont: UIFont?) {
        self.textColor = textColor
        self.textFont = textFont
        self.headingTextColor = headingTextColor
        self.headingTextFont = headingTextFont
    }
}

@objc public class CardinalButtonStyleManager: NSObject {
    // MARK: - colors

    @objc public let textColor: UIColor?
    @objc public let backgroundColor: UIColor?

    // MARK: - fonts

    @objc public let textFont: UIFont?

    // MARK: - sizes

    @objc public var cornerRadius: CGFloat

    @objc public init(textColor: UIColor?, textFont: UIFont?, backgroundColor: UIColor?, cornerRadius: CGFloat) {
        self.textColor = textColor
        self.textFont = textFont
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}

@objc public class CardinalStyleManager: NSObject {
    @objc public let labelStyleManager: CardinalLabelStyleManager?
    @objc public let verifyButtonStyleManager: CardinalButtonStyleManager?
    @objc public let continueButtonStyleManager: CardinalButtonStyleManager?
    @objc public let resendButtonStyleManager: CardinalButtonStyleManager?
    @objc public let cancelButtonStyleManager: CardinalButtonStyleManager?

    @objc public init(labelStyleManager: CardinalLabelStyleManager?, verifyButtonStyleManager: CardinalButtonStyleManager?, continueButtonStyleManager: CardinalButtonStyleManager?, resendButtonStyleManager: CardinalButtonStyleManager?, cancelButtonStyleManager: CardinalButtonStyleManager?) {
        self.labelStyleManager = labelStyleManager
        self.verifyButtonStyleManager = verifyButtonStyleManager
        self.continueButtonStyleManager = continueButtonStyleManager
        self.resendButtonStyleManager = resendButtonStyleManager
        self.cancelButtonStyleManager = cancelButtonStyleManager
    }
}
