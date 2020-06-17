//
//  AddCardButtonStyleManager.swift
//  SecureTradingUI
//

import UIKit

@objc public class AddCardButtonStyleManager: RequestButtonStyleManager {
    @objc public static func `default`() -> AddCardButtonStyleManager {
        return AddCardButtonStyleManager(titleColor: .white,
                                         enabledBackgroundColor: .black,
                                         disabledBackgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                                         borderColor: .clear,
                                         titleFont: UIFont.systemFont(ofSize: 16, weight: .medium),
                                         spinnerStyle: .white,
                                         spinnerColor: .white,
                                         buttonContentHeightMargins: HeightMargins(top: 15, bottom: 15),
                                         borderWidth: 0,
                                         cornerRadius: 6)
    }
}
