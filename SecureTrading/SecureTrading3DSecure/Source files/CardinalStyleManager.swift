//
//  CardinalStyleManager.swift
//  SecureTrading3DSecure
//

import UIKit

@objc public class CardinalFont: NSObject {
    @objc public var size: CGFloat
    @objc public var name: String?

    @objc public init(name: String? = nil, size: CGFloat) {
        self.name = name
        self.size = size
    }
}

@objc public class CardinalToolbarStyleManager: NSObject {
    // MARK: - colors

    @objc public let textColor: UIColor?
    @objc public let backgroundColor: UIColor?

    // MARK: - fonts

    @objc public let textFont: CardinalFont?

    // MARK: - texts

    @objc public let headerText: String?
    @objc public let buttonText: String?

    @objc public init(textColor: UIColor?, textFont: CardinalFont?, backgroundColor: UIColor?, headerText: String?, buttonText: String?) {
        self.textColor = textColor
        self.textFont = textFont
        self.backgroundColor = backgroundColor
        self.headerText = headerText
        self.buttonText = buttonText
    }
}

@objc public class CardinalLabelStyleManager: NSObject {
    // MARK: - colors

    @objc public let textColor: UIColor?
    @objc public let headingTextColor: UIColor?

    // MARK: - fonts

    @objc public let textFont: CardinalFont?
    @objc public let headingTextFont: CardinalFont?

    @objc public init(textColor: UIColor?, textFont: CardinalFont?, headingTextColor: UIColor?, headingTextFont: CardinalFont?) {
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

    @objc public let textFont: CardinalFont?

    // MARK: - sizes

    @objc public var cornerRadius: CGFloat

    @objc public init(textColor: UIColor?, textFont: CardinalFont?, backgroundColor: UIColor?, cornerRadius: CGFloat) {
        self.textColor = textColor
        self.textFont = textFont
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}

@objc public class CardinalTextBoxStyleManager: NSObject {
    // MARK: - colors

    @objc public let textColor: UIColor?
    @objc public let borderColor: UIColor?

    // MARK: - fonts

    @objc public let textFont: CardinalFont?

    // MARK: - sizes

    @objc public var cornerRadius: CGFloat
    @objc public var borderWidth: CGFloat

    @objc public init(textColor: UIColor?, textFont: CardinalFont?, borderColor: UIColor?, cornerRadius: CGFloat, borderWidth: CGFloat) {
        self.textColor = textColor
        self.textFont = textFont
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
    }
}

@objc public class CardinalStyleManager: NSObject {
    @objc public let toolbarStyleManager: CardinalToolbarStyleManager?
    @objc public let labelStyleManager: CardinalLabelStyleManager?
    @objc public let verifyButtonStyleManager: CardinalButtonStyleManager?
    @objc public let continueButtonStyleManager: CardinalButtonStyleManager?
    @objc public let resendButtonStyleManager: CardinalButtonStyleManager?
    @objc public let cancelButtonStyleManager: CardinalButtonStyleManager?
    @objc public let textBoxStyleManager: CardinalTextBoxStyleManager?

    @objc public init(toolbarStyleManager: CardinalToolbarStyleManager?, labelStyleManager: CardinalLabelStyleManager?, verifyButtonStyleManager: CardinalButtonStyleManager?, continueButtonStyleManager: CardinalButtonStyleManager?, resendButtonStyleManager: CardinalButtonStyleManager?, cancelButtonStyleManager: CardinalButtonStyleManager?, textBoxStyleManager: CardinalTextBoxStyleManager?) {
        self.toolbarStyleManager = toolbarStyleManager
        self.labelStyleManager = labelStyleManager
        self.verifyButtonStyleManager = verifyButtonStyleManager
        self.continueButtonStyleManager = continueButtonStyleManager
        self.resendButtonStyleManager = resendButtonStyleManager
        self.cancelButtonStyleManager = cancelButtonStyleManager
        self.textBoxStyleManager = textBoxStyleManager
    }
}
