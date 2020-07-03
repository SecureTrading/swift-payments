//
//  UIImageVIew.swift
//  SecureTradingUI
//

import UIKit.UIImageView

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
