//
//  Localizable.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation

protocol Localized {}

extension Localized where Self: RawRepresentable, Self.RawValue == String {
    var text: String {
        let selfClassName = String(describing: type(of: self))
        return NSLocalizedString("\(selfClassName).\(rawValue)", bundle: Bundle(for: BaseView.self), value: "No localized string found", comment: "")
    }
}

enum Localizable {
    enum TestPublic: String, Localized {
        case first
        case seccond
    }
}
