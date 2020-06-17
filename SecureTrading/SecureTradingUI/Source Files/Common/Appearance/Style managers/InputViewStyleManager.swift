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

    @objc public static func `default`() -> InputViewStyleManager {
        return InputViewStyleManager(titleColor: UIColor.gray,
                              textFieldBorderColor: UIColor.black.withAlphaComponent(0.8),
                              textFieldBackgroundColor: .clear,
                              textColor: .black,
                              placeholderColor: UIColor.lightGray.withAlphaComponent(0.8),
                              errorColor: UIColor.red.withAlphaComponent(0.8),
                              titleFont: UIFont.systemFont(ofSize: 16, weight: .regular),
                              textFont: UIFont.systemFont(ofSize: 16, weight: .regular),
                              placeholderFont: UIFont.systemFont(ofSize: 16, weight: .regular),
                              errorFont: UIFont.systemFont(ofSize: 12, weight: .regular),
                              textFieldImage: nil,
                              titleSpacing: 5,
                              errorSpacing: 3,
                              textFieldHeightMargins: HeightMargins(top: 10, bottom: 10),
                              textFieldBorderWidth: 1,
                              textFieldCornerRadius: 6)
    }
}
