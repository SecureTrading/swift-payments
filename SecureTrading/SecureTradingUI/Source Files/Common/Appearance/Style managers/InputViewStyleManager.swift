//
//  InputViewStyleManager.swift
//  SecureTradingUI
//

import UIKit

@objc public class HeightMargins: NSObject {
    @objc public var top: CGFloat
    @objc public var bottom: CGFloat

    @objc public init(top: CGFloat, bottom: CGFloat) {
        self.top = top
        self.bottom = bottom
    }
}

@objc public class InputViewStyleManager: NSObject {
    // MARK: - colors

    @objc public let titleColor: UIColor?
    @objc public let textFieldBorderColor: UIColor?
    @objc public let textFieldBackgroundColor: UIColor?
    @objc public let textColor: UIColor?
    @objc public let placeholderColor: UIColor?
    @objc public let errorColor: UIColor?

    // MARK: - fonts

    @objc public let titleFont: UIFont?
    @objc public let textFont: UIFont?
    @objc public let placeholderFont: UIFont?
    @objc public let errorFont: UIFont?

    // MARK: - images

    @objc public var textFieldImage: UIImage?

    // MARK: - spacing/sizes

    @objc public var titleSpacing: CGFloat
    @objc public var errorSpacing: CGFloat
    @objc public var textFieldHeightMargins: HeightMargins?
    @objc public var textFieldBorderWidth: CGFloat
    @objc public var textFieldCornerRadius: CGFloat

    @objc public init(titleColor: UIColor?, textFieldBorderColor: UIColor?, textFieldBackgroundColor: UIColor?, textColor: UIColor?, placeholderColor: UIColor?, errorColor: UIColor?, titleFont: UIFont?, textFont: UIFont?, placeholderFont: UIFont?, errorFont: UIFont?, textFieldImage: UIImage?, titleSpacing: CGFloat = 5, errorSpacing: CGFloat = 5, textFieldHeightMargins: HeightMargins? = nil, textFieldBorderWidth: CGFloat = 2, textFieldCornerRadius: CGFloat = 5) {
        self.titleColor = titleColor
        self.textFieldBorderColor = textFieldBorderColor
        self.textFieldBackgroundColor = textFieldBackgroundColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.errorColor = errorColor
        self.titleFont = titleFont
        self.textFont = textFont
        self.placeholderFont = placeholderFont
        self.errorFont = errorFont
        self.textFieldImage = textFieldImage
        self.titleSpacing = titleSpacing
        self.errorSpacing = errorSpacing
        self.textFieldHeightMargins = textFieldHeightMargins
        self.textFieldBorderWidth = textFieldBorderWidth
        self.textFieldCornerRadius = textFieldCornerRadius
    }
}
