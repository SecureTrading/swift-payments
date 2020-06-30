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

    // no need to expose this property publicly
    let visibleFields: [DropInViewVisibleFields]

    @objc public init(inputViewStyleManager: InputViewStyleManager?,
                      visibleFields: [Int] = DropInViewVisibleFields.allCases.map { $0.rawValue },
                      requestButtonStyleManager: RequestButtonStyleManager?,
                      backgroundColor: UIColor?,
                      spacingBeetwenInputViews: CGFloat = 30,
                      insets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: -15, right: -30)) {
        self.inputViewStyleManager = inputViewStyleManager
        self.visibleFields = visibleFields.compactMap { DropInViewVisibleFields(rawValue: $0) }
        self.requestButtonStyleManager = requestButtonStyleManager
        self.backgroundColor = backgroundColor
        self.spacingBeetwenInputViews = spacingBeetwenInputViews
        self.insets = insets
    }

    public init(inputViewStyleManager: InputViewStyleManager?,
                visibleFields: [DropInViewVisibleFields] = DropInViewVisibleFields.allCases,
                requestButtonStyleManager: RequestButtonStyleManager?,
                backgroundColor: UIColor?,
                spacingBeetwenInputViews: CGFloat = 30,
                insets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: -15, right: -30)) {
        self.inputViewStyleManager = inputViewStyleManager
        self.visibleFields = visibleFields
        self.requestButtonStyleManager = requestButtonStyleManager
        self.backgroundColor = backgroundColor
        self.spacingBeetwenInputViews = spacingBeetwenInputViews
        self.insets = insets
    }
}

@objc public enum DropInViewVisibleFields: Int, CaseIterable {
    case pan = 0
    case expiryDate
    case securityCode3
    case securityCode4
}
