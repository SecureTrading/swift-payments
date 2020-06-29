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
    let fieldsToSubmit: [DropInFieldsToSubmit]

    @objc public init(inputViewStyleManager: InputViewStyleManager?,
                      fieldsToSubmit: [Int] = DropInFieldsToSubmit.allCases.map { $0.rawValue },
                      requestButtonStyleManager: RequestButtonStyleManager?,
                      backgroundColor: UIColor?,
                      spacingBeetwenInputViews: CGFloat = 30,
                      insets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: -15, right: -30)) {
        self.inputViewStyleManager = inputViewStyleManager
        self.fieldsToSubmit = fieldsToSubmit.compactMap { DropInFieldsToSubmit(rawValue: $0) }
        self.requestButtonStyleManager = requestButtonStyleManager
        self.backgroundColor = backgroundColor
        self.spacingBeetwenInputViews = spacingBeetwenInputViews
        self.insets = insets
    }

    public init(inputViewStyleManager: InputViewStyleManager?,
                fieldsToSubmit: [DropInFieldsToSubmit] = DropInFieldsToSubmit.allCases,
                requestButtonStyleManager: RequestButtonStyleManager?,
                backgroundColor: UIColor?,
                spacingBeetwenInputViews: CGFloat = 30,
                insets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: -15, right: -30)) {
        self.inputViewStyleManager = inputViewStyleManager
        self.fieldsToSubmit = fieldsToSubmit
        self.requestButtonStyleManager = requestButtonStyleManager
        self.backgroundColor = backgroundColor
        self.spacingBeetwenInputViews = spacingBeetwenInputViews
        self.insets = insets
    }
}

@objc public enum DropInFieldsToSubmit: Int, CaseIterable {
    case pan = 0
    case expiryDate
    case securityCode
}
